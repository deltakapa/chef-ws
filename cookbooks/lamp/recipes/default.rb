#
# Cookbook:: LAMP
# Recipe:: Update system and install lamp
#
# Copyright:: 2018, The Authors, All Rights Reserved.

execute "update-upgrade" do
  command "apt-get update -y"
  action :run
end


package "apache2" do
  action :install
end


service "apache2" do
  action [:enable, :start]
end


package "php5" do
  action :install
end


package "php-pear" do
  action :install
end


package "php5-mysql" do
  action :install
end

include_recipe 'lamp::mysql'
