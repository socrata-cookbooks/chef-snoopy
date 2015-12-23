# Encoding: UTF-8
#
# Ensure rsyslog is installed and running, regardless of whether the build
# environment is a Vagrant box or a Docker container with no init system.
#

package 'rsyslog'
file '/etc/rsyslog.conf' do
  content <<-EOH.gsub(/^ {4}/, '')
    $ModLoad imuxsock
    $WorkDirectory /var/lib/rsyslog
    $ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
    $OmitLocalLogging off
    *.info;mail.none;authpriv.none;cron.none /var/log/messages
    authpriv.* /var/log/secure
    mail.* -/var/log/maillog
    cron.* /var/log/cron
    *.emerg :omusrmsg:*
    uucp,news.crit /var/log/spooler
    local7.* /var/log/boot.log
  EOH
  only_if do
    node['platform_family'] == 'rhel' && \
      node['platform_version'].to_i >= 7 && \
      File.open('/proc/1/cmdline').read.start_with?('/usr/sbin/sshd')
  end
end
execute 'rsyslogd' do
  ignore_failure true
end

# TODO: Pending a patch to the packagecloud cookbook to ensure it's installed
package 'wget'

include_recipe 'snoopy'
