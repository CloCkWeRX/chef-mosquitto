server_packages = %w{mosquitto}

server_packages.each do |pkg|
  package pkg
end

template "/etc/mosquitto/conf.d/mosquitto.conf" do
  source "mosquitto.conf.erb"

  mode 0640

  # notifies :restart, "service[mosquitto]"
end