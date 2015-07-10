dev_tools = %w[autoconf automake binutils bison flex gcc gcc-c++ gettext libtool make patch pkgconfig redhat-rpm-config rpm-build git openssl-devel cmake c-ares-devel libuuid-devel libxslt docbook-xsl]

dev_tools.each do |pkg|
  yum_package pkg do
    action :install
  end
end

script 'install libwebsockets' do
  not_if { File.exists?('/usr/local/lib64/libwebsockets.so.4.0.0') }
  interpreter 'bash'
  user 'root'
  cwd '/tmp'
  code <<-EOF
    wget https://github.com/warmcat/libwebsockets/archive/v1.3-chrome37-firefox30.tar.gz -O v1.3-chrome37-firefox30.tar.gz
    tar zxvf v1.3-chrome37-firefox30.tar.gz
    rm -f v1.3-chrome37-firefox30.tar.gz
    cd libwebsockets-1.3-chrome37-firefox30
    mkdir build
    cd build
    cmake .. -DLIB_SUFFIX=64
    sudo make install
    sudo ln -s /usr/local/lib64/libwebsockets.so.4.0.0 /usr/lib/libwebsockets.so.4.0.0
    sudo ln -s /usr/lib/libwebsockets.so.4.0.0 /usr/lib64/libwebsockets.so.4.0.0
    cd ../..
    rm -rf libwebsockets-1.3-chrome37-firefox30
  EOF
end

script 'install mosquitto with websockets enabled' do
  not_if { File.exists?('/usr/sbin/mosquitto') }
  interpreter 'bash'
  user 'root'
  cwd '/tmp'
  code [
    'git clone https://git.eclipse.org/r/mosquitto/org.eclipse.mosquitto',
    'cd org.eclipse.mosquitto/',
    'git checkout v1.4.2',
    "sed -i 's/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/g' config.mk",
    "sed -i 's/prefix=\/usr\/local/prefix=\/usr/g' config.mk",
    'make binary',
    'sudo make install',
    'cd ..',
    'rm -rf org.eclipse.mosquitto'
  ].join(" && ")
end

directory '/etc/mosquitto' do
  action :create
end

template "/etc/mosquitto/mosquitto.conf" do
  source "mosquitto.conf.erb"

  mode 0640

  notifies :reload, "service[mosquitto]"
end

template '/etc/init.d/mosquitto' do
  source 'initd'

  owner 'root'
  group 'root'
  mode 0755

  notifies :restart, "service[mosquitto]"
end