# frozen_string_literal: true

Facter.add(:arc_version) do
  # https://puppet.com/docs/puppet/latest/fact_overview.html
  setcode do
    Facter::Util::Resolution::exec('/usr/sbin/arched --version').split(' ')[2]
  end
end
