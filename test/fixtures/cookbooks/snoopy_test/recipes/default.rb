# Encoding: UTF-8

service 'rsyslog' do
  start_command 'service rsyslog start'
  action [:enable, :start]
end

include_recipe 'snoopy'
