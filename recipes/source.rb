dev_tools = %w[wget autoconf automake binutils bison flex gcc gcc-c++ gettext libtool make patch pkgconfig redhat-rpm-config rpm-build git openssl-devel cmake c-ares-devel libuuid-devel libxslt docbook-xsl]

dev_tools.each do |pkg|
  yum_package pkg do
    action :install
  end
end

script 'install libwebsockets' do
  not_if { File.exists?('/usr/local/lib64/libwebsockets.so.6') }
  interpreter 'bash'
  user 'root'
  cwd '/tmp'
  code [
    %q[wget https://github.com/warmcat/libwebsockets/archive/v1.6.0-chrome48-firefox42.tar.gz -O v1.6.0-chrome48-firefox42.tar.gz],
    %q[tar zxvf v1.6.0-chrome48-firefox42.tar.gz],
    %q[rm -f v1.6.0-chrome48-firefox42.tar.gz],
    %q[cd libwebsockets-1.6.0-chrome48-firefox42],
    %q[mkdir -p build],
    %q[cd build],
    %q[cmake .. -DLIB_SUFFIX=64],
    %q[make],
    %q[make install],
    %q[ln -s /usr/local/lib64/libwebsockets.so.6 /usr/lib/libwebsockets.so.6],
    %q[ln -s /usr/lib/libwebsockets.so.6 /usr/lib64/libwebsockets.so.6],
    %q[cd ../..],
    %q[rm -rf libwebsockets-1.6.0-chrome48-firefox42]
  ].join(" && ")
end


user "#{node['mosquitto']['user']}"

group "#{node['mosquitto']['user']}" do
  members ["#{node['mosquitto']['user']}"]
end

script 'install mosquitto with websockets enabled' do
  not_if { File.exists?('/usr/sbin/mosquitto') }
  interpreter 'bash'
  user 'root'
  cwd '/tmp'
  code [
    'rm -rf org.eclipse.mosquitto',
    'git clone https://git.eclipse.org/r/mosquitto/org.eclipse.mosquitto',
    'cd org.eclipse.mosquitto/',
    'git checkout v1.4.8',
    %q[sed -i 's/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/g' config.mk],
    %q[sed -i 's/prefix=\/usr\/local/prefix=\/usr/g' config.mk],
    %q[sed -i 's/DOCDIRS=man/DOCDIRS=/g' Makefile], # DO NOT INCLUDE DOCS in make install
    'make install', # https://bugs.launchpad.net/mosquitto/+bug/1269967
    %q[echo "/usr/lib" >> /etc/ld.so.conf.d/mosquitto.conf],
    %q[ldconfig],
    %Q[mkdir -p #{node['mosquitto']['persistence_location']}],
    %Q[chown #{node['mosquitto']['user']} #{node['mosquitto']['persistence_location']}],
    'cd ..',
    'rm -rf org.eclipse.mosquitto'
  ].join(" && ")
end

directory '/etc/mosquitto' do
  action :create
end

directory '/etc/mosquitto/plugin_config' do
  action :create
end

template "/etc/mosquitto/mosquitto.conf" do
  source "mosquitto.conf.erb"

  mode 0640
end

template '/etc/init.d/mosquitto' do
  source 'initd'

  owner 'root'
  group 'root'
  mode 0755
end
