server_packages = %w{mosquitto}

server_packages.each do |pkg|
  package pkg
end

template "/etc/mosquitto/mosquitto.conf" do
  source "mosquitto.conf.erb"

  mode 0640
end

service 'mosquitto' do
  # provider service_provider
  service_name 'mosquitto'

  supports :restart => true

  action [:enable, :start]

  subscribes :restart, "/etc/mosquitto/mosquitto.conf", :immediately
end
