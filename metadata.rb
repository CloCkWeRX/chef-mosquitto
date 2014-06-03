name      "mosquitto"
maintainer        "Daniel O'Connor"
maintainer_email  "daniel.oconnor@gmail.com"
license           "MIT"
description       "Installs and configures mosquitto, an MQTT broker"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"
recipe            "mosquitto", "Includes the recipe to configure the broker"

%w{ debian ubuntu mac_os_x }.each do |os|
  supports os
end

depends 'apt'