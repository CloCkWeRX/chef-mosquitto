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

```bridges``` - An array of bridge connections to make.

```
{
  "mosquitto": {
    "bridges": [{
      "connection": "test-mosquitto-org"
      "address": "test.mosquitto.org",
      "cleansession": "true",
      "topics": ["clients/total in 0 test/mosquitto/org $SYS/broker/"]
    }]
  }
}

All of the standard configuration options are supported.
See http://mosquitto.org/man/mosquitto-conf-5.html for more.
