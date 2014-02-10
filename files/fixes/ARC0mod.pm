package ARC0mod;

#
# Loads ARC0.6 LRMS modules for use with ARC1
#

# To include a new (ARC 0.6) LRMS plugin:
#
# 1. Each LRMS specific module needs to provide subroutines
#    cluster_info, queue_info, jobs_info, and users_info.
#    
# 2. References to subroutines defined in new LRMS modules are added
#    to the select_lrms subroutine in this module, and the module reference
#    itself, naturally.

# NB: ARC0 modules use minutes for time units. ARC1 modules use seconds.



require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(get_lrms_info get_lrms_options_schema);

use LogUtils;
use strict;

our $log = LogUtils->getLogger(__PACKAGE__);

our %modnames = ( PBS    => "PBS",
                  SGE    => "SGE",
                  LL     => "LL",
                  LSF    => "LSF",
                  DGBRIDGE  => "DGBridge",
                  CONDOR => "Condor",
                  SLURM  => "SLURM",
                  FORK   => "Fork"
                );

# Whether the module implements support for listing nodes.
our $has_nodes = 1;

sub load_lrms($) {
    my $lrms_name = uc(shift);
    my $module = $modnames{$lrms_name};
    $log->error("No ARC0 module for $lrms_name") unless $module;
    eval { require "$module.pm" };
    $log->error("Failed to load LRMS module $module: $@") if $@;
    import $module qw(cluster_info queue_info jobs_info users_info);
    eval { import $module qw(nodes_info) };
    if ($@) {
        $log->debug("LRMS module $module does not export 'nodes_info'");
        $has_nodes=0;
    }
    $LogUtils::default_logger = LogUtils->getLogger($module);
}

# Just generic options, cannot assume anything LRMS specific here

sub get_lrms_options_schema {
    return {
        'lrms' => '',              # name of the LRMS module
        'queues' => {              # queue names are keys in this hash
            '*' => {
                'users' => [ '' ]  # list of user IDs to query in the LRMS
            }
        },
        'jobs' => [ '' ]           # list of jobs IDs to query in the LRMS
    }
}


sub get_lrms_info($) {
    my $options = shift;

    my %cluster_config = %$options;
    delete $cluster_config{queues};
    delete $cluster_config{jobs};

    my $lrms_info = {cluster => {}, queues => {}, jobs => {}};

    my $cluster_info = { cluster_info(\%cluster_config) };
    delete $cluster_info->{queue};
    $lrms_info->{cluster} = delete_empty($cluster_info);

    $lrms_info->{nodes} = { nodes_info(\%cluster_config) } if $has_nodes;

    for my $qname ( keys %{$options->{queues}} ) {

        my %queue_config = (%cluster_config, %{$options->{queues}{$qname}});
        delete $queue_config{users};

        my $jids = $options->{jobs};

        # TODO: interface change: jobs under each queue
        my $jobs_info = { jobs_info(\%queue_config, $qname, $jids) };
        for my $job ( values %$jobs_info ) {
            $job->{status} ||= 'EXECUTED';
            delete_empty($job);
        }
        $lrms_info->{jobs} = { %{$lrms_info->{jobs}}, %$jobs_info };

        my $queue_info = { queue_info(\%queue_config, $qname) };
	if ( $qname eq 'AMDexpress' ) {
    	$queue_info->{maxwalltime} = '60';
    	$queue_info->{minwalltime} = '0';
	$queue_info->{defaultwallt} = '55';
	$queue_info->{maxcputime} = '60';
	$queue_info->{mincputime} = '0';
	$queue_info->{defaultcput} = '55';
     } elsif ( $qname eq 'AMDshort' ) {
    	$queue_info->{maxwalltime} = '30';
    	$queue_info->{minwalltime} = '0';
	$queue_info->{defaultwallt} = '25';
	$queue_info->{maxcputime} = '30';
	$queue_info->{mincputime} = '0';
	$queue_info->{defaultcput} = '25';
     } elsif ( $qname eq 'AMDmedium' ) {
    	$queue_info->{maxwalltime} = '4320';
    	$queue_info->{minwalltime} = '0';
	$queue_info->{defaultwallt} = '4300';
	$queue_info->{maxcputime} = '4320';
	$queue_info->{mincputime} = '0';
	$queue_info->{defaultcput} = '4300';
     } elsif ( $qname eq 'AMDlong' ){
    	$queue_info->{maxwalltime} = '4800';
    	$queue_info->{minwalltime} = '0';
	$queue_info->{defaultwallt} = '4700';
	$queue_info->{maxcputime} = '4800';
	$queue_info->{mincputime} = '0';
	$queue_info->{defaultcput} = '4700';
     }
        $lrms_info->{queues}{$qname} = delete_empty($queue_info);

        my $users = $options->{queues}{$qname}{users};

        $queue_info->{users} = { users_info(\%queue_config, $qname, $users) };
        for my $user ( values %{$queue_info->{users}} ) {
            my $freecpus = $user->{freecpus};
            $user->{freecpus} = split_freecpus($freecpus) if defined $freecpus;
            delete_empty($user);
        }
        $queue_info->{acl_users} = $queue_config{acl_users}
            if defined $queue_config{acl_users};
    }

    # ARC0 LRMS plugins use minutes. Convert to seconds here.

    for my $queue (values %{$lrms_info->{queues}}) {
        $queue->{minwalltime} = int 60*$queue->{minwalltime} if $queue->{minwalltime};
        $queue->{mincputime}  = int 60*$queue->{mincputime}  if $queue->{mincputime};
        $queue->{maxwalltime} = int 60*$queue->{maxwalltime} if $queue->{maxwalltime};
        $queue->{maxcputime}  = int 60*$queue->{maxcputime}  if $queue->{maxcputime};
        $queue->{defaultwallt} = int 60*$queue->{defaultwallt} if $queue->{defaultwallt};
        $queue->{defaultcput}  = int 60*$queue->{defaultcput}  if $queue->{defaultcput};
    }

    for my $job (values %{$lrms_info->{jobs}}) {
        $job->{reqcputime}  = int 60*$job->{reqcputime}  if $job->{reqcputime};
        $job->{reqwalltime} = int 60*$job->{reqwalltime} if $job->{reqwalltime};
        $job->{cputime}     = int 60*$job->{cputime}     if $job->{cputime};
        $job->{walltime}    = int 60*$job->{walltime}    if $job->{walltime};
        delete $job->{nodes} unless @{$job->{nodes}};
        delete $job->{comment} unless @{$job->{comment}};
    }

    return $lrms_info;
}


sub delete_empty($) {
    my $hashref = shift;
    foreach my $k ( keys %$hashref) {
        delete $hashref->{$k}
            if ! defined $hashref->{$k} || $hashref->{$k} eq '';
    }
    return $hashref;
}

# Convert frecpus string into a hash.
# Example: "6 11:2880 23:1440" --> { 6 => 0, 11 => 2880, 23 => 1440 }

# OBS: Assuming the function cpu vs. time is monotone, this transformation is safe.

sub split_freecpus($) {
    my $freecpus_string = shift;
    my $freecpus_hash = {};
    for my $countsecs (split ' ', $freecpus_string) {
        if ($countsecs =~ /^(\d+)(?::(\d+))?$/) {
            $freecpus_hash->{$1} = $2 || 0; # 0 means unlimited
        } else {
            $log->warning("Bad freecpus string: $freecpus_string");
            return {};
        }
    }
    return $freecpus_hash;
}

1;
