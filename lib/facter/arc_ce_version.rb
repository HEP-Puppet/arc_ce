# Fact: arc_ce_version
#
# Purpose: Report the version of Nordugrid ARC CE
#
require 'facter'

result = %x{/bin/rpm -q --queryformat "%{VERSION}-%{RELEASE}" nordugrid-arc}
Facter.add(:arc_ce_version) do
  setcode do
    begin
      Facter::Util::Resolution.exec('/bin/rpm -q --queryformat "%{VERSION}-%{RELEASE}" nordugrid-arc 2>&1') 
    rescue Exception
      Facter.debug('nordugrid-arc not installed')
    end
  end
end
