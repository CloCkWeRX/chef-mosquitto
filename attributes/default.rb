case node['platform']
when "debian", "ubuntu"
  default['mosquitto']['path'] = '/etc/mosquitto/'
when "redhat", "centos", "scientific", "fedora", "arch", "amazon"
  default['mosquitto']['path'] = '/etc/mosquitto/'
else
  default['mosquitto']['path'] = '/tmp/mosquitto'
end

default['mosquitto']['listeners'] = [
  {port: 1883, addr: '127.0.0.1'}, 
  {port: '8883'}
]

default['mosquitto']['tls_version'] = nil
default['mosquitto']['autosave_interval'] = '1800'
default['mosquitto']['allow_anonymous'] = "false"

default['mosquitto']['connection_messages'] = "true"

default['mosquitto']['persistence'] = "true"

default['mosquitto']['persistence_location'] = "/tmp/"

default['mosquitto']['persistence_file'] = "mosquitto.db"

default['mosquitto']['persistent_client_expiration'] = "1m"

default['mosquitto']['retained_persistence'] = "true"

default['mosquitto']['require_certificate'] = "false"

default['mosquitto']['bridges'] = []
default['mosquitto']['listeners'] = []
