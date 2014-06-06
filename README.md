chef-mosquitto
==============

A cookbook for mosquitto, a MQTT server, client, etc.

### Recipes

```repo``` - Adds the repository if needed for various packages

```server``` - Recipe to install service packages

```client``` - Recipe to install client and language bindings

```default``` - Installs everything

### Typical deployment

Deploy to /etc/mosquitto and run on ports 1883 and 8883 with security.

```
{
  "run_list": "recipe[mosquitto]",
  "mosquitto": {
    "path": "/etc/mosquitto/",
    "listeners": [
      {"port": 1883, "addr": "127.0.0.1"}, 
      {"port": 8883}
    ],
    "tls_version": "tlsv1",
    "cafile": "ca.crt"
    "certfile": "server.crt"
    "keyfile": "server.key"
  }

}
```


#### Add your keys

Don't forget to set up your keys.

```
%w{server.key ca.crt server.crt}.each do |file_name|
  file "#{node['mosquitto']['path']}/#{node['mosquitto'][file]}" do
    content content File.read(#{Chef::Config[:file_cache_path]}/site-cookbooks/your-app/files/default/#{file_name}")

    action :create_if_missing

    notifies :restart, "service[mosquitto]"
  end
end
```

### Simple deployment

```
{
  "run_list": "recipe[mosquitto]",
  "mosquitto": {
    "listeners": [
      {"port": 1883, "addr": "127.0.0.1"}
    ],
  }

}
```

### Config options

```listeners[]``` - An array of port/address hashes to listen on. Addr is optional. Defaults to ```8883``` and ```1883```

```path``` - Override the automatically guessed path

``````