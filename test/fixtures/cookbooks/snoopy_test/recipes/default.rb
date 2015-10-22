# Encoding: UTF-8

service 'rsyslog' do
  action [:enable, :start]
end

include_recipe 'snoopy'
