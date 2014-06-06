chef-mosquitto
==============

A cookbook for mosquitto, a MQTT server, client, etc.

Tested on:

 * Centos 6
 * Ubuntu 12.04

... but Centos 5, Mac OSX, Debian, various flavours of Ubuntu should work.


### Recipes

```repo``` - Adds the repository if needed for various packages

```server``` - Recipe to install service packages

```client``` - Recipe to install client and language bindings

```default``` - Installs everything


### Simple deployment

```
{
  "run_list": ["recipe[mosquitto]", "recipe[mine]"],
  "mosquitto": {
    "listeners": [
      {"port": 1883, "addr": "127.0.0.1"}
    ]
  }

}
```

Don't forget to start the service
```
service 'mosquitto' do
  action :start
end
```

### Typical deployment

Deploy to /etc/mosquitto and run on ports 1883 and 8883 with security.

```
{
  "run_list": ["recipe[mosquitto]", "recipe[mine]"],
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

Don't forget to start the service
```
service 'mosquitto' do
  action :start
end
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


### Config options

```listeners[]``` - An array of port/address hashes to listen on. Addr is optional. Defaults to ```8883``` and ```1883```

```path``` - Override the automatically guessed path

```tls_version``` - Defaults to nil. If you specify a value ('tls_v1') you must provide ```cafile```, ```keyfile```, and ```certfile```.

```cafile``` - Short name for file. Assumes ```node['mosquitto']['path']```.

```certfile``` - Short name for file. Assumes ```node['mosquitto']['path']```.

```keyfile``` - Short name for file. Assumes ```node['mosquitto']['path']```.

```allow_anonymous``` - Allow anonymous? Defaults to ```"false"```

```autosave_interval``` - Defaults to '1800'

```allow_anonymous``` - Defaults to "false"

```connection_messages``` - Defaults to "true"

```persistence``` - Defaults to "true"

```persistence_location``` - Defaults to "/tmp/"

```persistence_file``` - Defaults to "mosquitto.db"

```persistent_client_expiration``` - Defaults to "1m"

```retained_persistence``` - Defaults to "true"

```require_certificate``` - Defaults to "false"