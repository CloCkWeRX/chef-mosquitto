#
# Cookbook Name:: mosquitto
# Recipe:: default
#


case node['platform']
when 'ubuntu'
  # Ubuntu 14.04+ appears to have the right packages
  if node['platform_version'].to_f <= 14.04
    # May not be needed in modern ubuntu, debian.
    apt_repository 'mosquitto' do
      uri          'http://repo.mosquitto.org/debian'
      distribution node['lsb']['codename']
      components   ['main']
      key          'http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key'
    end
  end

when 'debian'
  # Debian 7.0 or lower need the repo (wheezy)
  if node['platform_version'].to_i <= 7
    # May not be needed in modern ubuntu, debian.
    apt_repository 'mosquitto' do
      uri          'http://repo.mosquitto.org/debian'
      distribution node['lsb']['codename']
      components   ['main']
      key          'http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key'
    end
  end
when "mac_os_x"
  # Supported by brew
when "centos"
  # http://mosquitto.org/download/
  #
  # CentOS

  # Download the repository config file for your CentOS version from below and copy it to /etc/yum.repos.d/ You’ll now be able to install and keep mosquitto up to date using the normal package management tools.

  # The available packages are: mosquitto, mosquitto-clients, libmosquitto1, libmosquitto-devel, libmosquittopp1, libmosquittopp-devel, python-mosquitto.

  # CentOS 6
  # CentOS 5
  raise "Not yet supported, but pull requests welcome!"
else
  raise "Not yet supported, but pull requests welcome!"
end


package "mosquitto"


template "/etc/mosquitto/conf.d/mosquitto.conf" do
  source "mosquitto.conf.erb"

  mode 0640

  notifies :restart, "service[mosquitto]"
end
