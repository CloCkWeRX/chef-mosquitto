client_packages = %w{mosquitto-clients libmosquitto1 libmosquitto-devel libmosquittopp1 libmosquittopp-devel python-mosquitto}

case node['platform']
when 'ubuntu'

when 'debian'

when "mac_os_x"
  # Supported by brew
when "redhat", "centos", "scientific", "fedora", "arch", "amazon"
 
  client_packages = %w{mosquitto-clients libmosquitto1 libmosquitto-devel libmosquittopp1 libmosquittopp-devel python-mosquitto}
end

# Todo different recipe?
client_packages.each do |pkg|
  package pkg
end

