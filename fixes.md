# Fixes
Several fixes are necessary in order to make the ARC CE work with HTCondor

## /usr/share/arc/submit-condor-job
Fixes bug https://bugzilla.nordugrid.org/show_bug.cgi?id=3281 for ARC CE <= 4.0.0
```perl
$output .= "Output = $grami{joboption_directory}.comment\n";
$output .= "Error = $grami{joboption_directory}.comment\n";
```
to
```perl
    my $file_stdout = notnull($grami{joboption_stdout}) ? $grami{joboption_stdout} : $grami{joboption_directory}.".comment";
    my $file_stderr = notnull($grami{joboption_stderr}) ? $grami{joboption_stderr} : $grami{joboption_directory}.".comment";

    $output .= "Log = $condor_log\n";
    if ($file_stdout =~ /_condor_stdout/)
    {
       $output .= "Output = $file_stdout\n";
    }
    else
    {
       $output .= "Output = $grami{joboption_directory}.comment\n";

    }

    if ($file_stderr =~ /_condor_stderr/)
    {
       $output .= "Error = $file_stderr\n";
    }
    else
    {
       $output .= "Error = $grami{joboption_directory}.comment\n";
    }
```

## Number of cores reported
Changed number of machines in /usr/share/arc/Condor.pm from
```perl
$machines{$$_{machine}}++ for @allnodedata;
```
to
```perl
$machines{$$_{machine}} = $$_{totalcpus} for @allnodedata;
```

## Default queue limits
Changed default limits in /usr/share/arc/Condor.pm from
```perl
    $lrms_queue{maxwalltime} = '';
    $lrms_queue{minwalltime} = '';
    $lrms_queue{defaultwallt} = '';
    $lrms_queue{maxcputime} = '';
    $lrms_queue{mincputime} = '';
    $lrms_queue{defaultcput} = '';
```
to
```perl
    $lrms_queue{maxwalltime} = '6480';
    $lrms_queue{minwalltime} = '0';
    $lrms_queue{defaultwallt} = '2880';
    $lrms_queue{maxcputime} = '6480';
    $lrms_queue{mincputime} = '0';
    $lrms_queue{defaultcput} = '2880';
```
