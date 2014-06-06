server_packages = %w{mosquitto}

server_packages.each do |pkg|
  package pkg
end

template "/etc/mosquitto/mosquitto.conf" do
  source "mosquitto.conf.erb"

  mode 0640

  notifies :restart, "service[mosquitto]"
end

service 'mosquitto' do
  # provider service_provider
  service_name 'mosquitto'

  supports restart: true, status: true, reload: true

  action :nothing
end
