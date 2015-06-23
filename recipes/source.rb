dev_tools = %w[autoconf automake binutils bison flex gcc gcc-c++ gettext libtool make patch pkgconfig redhat-rpm-config rpm-build git openssl-devel cmake c-ares-devel libuuid-devel libxslt]

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
    wget https://github.com/warmcat/libwebsockets/archive/v1.3-chrome37-firefox30.tar.gz
    tar zxvf v1.3-chrome37-firefox30.tar.gz
    rm v1.3-chrome37-firefox30.tar.gz
    cd libwebsockets-1.3-chrome37-firefox30
    mkdir build
    cd build
    cmake .. -DLIB_SUFFIX=64
    sudo make install
    sudo ln -s /usr/local/lib64/libwebsockets.so.4.0.0 /usr/lib/libwebsockets.so.4.0.0
    cd ../..
    rm -rf libwebsockets-1.3-chrome37-firefox30
  EOF
end

script 'install mosquitto with websockets enabled' do
  not_if { File.exists?('/usr/local/sbin/mosquitto') }
  interpreter 'bash'
  user 'root'
  cwd '/tmp'
  code <<-EOF
    git clone https://git.eclipse.org/r/mosquitto/org.eclipse.mosquitto
    cd org.eclipse.mosquitto/
    git checkout origin/1.4
    sed -i 's/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/g' config.mk
    make binary
    sudo make install ||
    cd ..
    rm -rf org.eclipse.mosquitto
  EOF
end
