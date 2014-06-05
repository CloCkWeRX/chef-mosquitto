case node['platform_family']
when "debian", "ubuntu"
  default['mosquitto']['path'] = '/etc/mosquitto/'
else
  default['mosquitto']['path'] = '/tmp/mosquitto'
end

default['mosquitto']['listeners'] = [
  {port: 1883, addr: '127.0.0.1'}, 
  {port: '8883'}
]
default['mosquitto']['tls_version'] = 'tlsv1'

