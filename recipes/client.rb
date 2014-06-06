client_packages = %w{mosquitto-clients libmosquitto1 libmosquitto-devel libmosquittopp1 libmosquittopp-devel python-mosquitto}

case node['platform']
when 'ubuntu', 'debian'
  client_packages = %w{mosquitto-clients libmosquitto0 libmosquitto0-dev libmosquittopp0 libmosquittopp0-dev python-mosquitto}
when "redhat", "centos", "scientific", "fedora", "arch", "amazon"
  client_packages = %w{mosquitto-clients libmosquitto1 libmosquitto-devel libmosquittopp1 libmosquittopp-devel python-mosquitto}
end

client_packages.each do |pkg|
  package pkg
end

