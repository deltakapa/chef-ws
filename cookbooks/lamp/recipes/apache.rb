#
# Cookbook:: lamp
# Recipe:: apache-config (single site)
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#The recursive property ensures that any parent directories are created, so as the document root directory to be successfully created. Document root is read from attributes file. 
directory node['lamp']['web']['document_root'] do
  mode '0644'
  recursive true
end

#Make a copy of apache.conf
ruby_block "Rename file" do
  block do
    ::FileUtils.cp '/etc/apache2/apache2.conf', '/etc/apache2/apache2.conf.bak'
  end
end

#The action :nothing directive means the resource will wait to be called on. a2enmod enables specified mpm module. a2dismod disables specified mpm module. a2ensite enables specified site. a2dissite disables specified site.
execute "enable-event" do
  command "a2dismod mpm_prefork"
  command "a2dismod mpm_work"
  command "a2enmod mpm_event"
  command "a2dissite 000-default"
  command "a2ensite 001-site"
  action :nothing
end


#Because the MPM needs to be re-enabled, after mpm_event file update, in order to use the new configuration option, we should use the notifies command again, to execute a2enmod mpm_event.
cookbook_file "/etc/apache2/mods-available/mpm_event.conf" do
  source "mpm_event.conf"
  mode "0644"
  notifies :run, "execute[enable-event]"
end

#Use the template create for apache.conf. notifies command does notify Chef when things have changed, and only then runs the restart apache2 service.
template '/etc/apache2/sites-available/001-site.conf' do
  source 'vhosttemplate.conf.erb'
  mode '0755'
end

#set phpinfo.php from templates, as landing page (document root).
template "#{node['lamp']['web']['document_root']}/phpinfo.php" do
  source 'phpinfo.php.erb'
  mode '0644'
end

#restart apache to apply the new configuration.
service "apache2" do
  action [:restart]
end
