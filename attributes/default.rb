case node['platform_family']
when "debian", "ubuntu"
  defaults['mosquitto']['path'] = '/etc/mosquitto/'
else
  defaults['mosquitto']['path'] = '/tmp/mosquitto'
end

defaults['mosquitto']['listeners'] = [
  {port: 1883, addr: '127.0.0.1'}, 
  {port: '8883'}
]
defaults['mosquitto']['tls_version'] = 'tlsv1'

