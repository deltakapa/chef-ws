#
# Cookbook:: lamp
# Recipe:: apache-config (multiple vhost site - dynamic configuration)
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#Create the document root directory, according to the sites defined in attributes files. The recursive property ensures that any parent directories are created, so as the document root directory to be successfully created. Document root is read from attributes file. 
node['lamp']['web']['site'].each do |sitename, data|
  document_root = "#{node['lamp']['web']['vhost_document_root']}/#{sitename}/public_html"
  directory document_root do
    mode '0755'
    recursive true
  end
end


#Make a copy of original apache.conf
ruby_block "SaveOriginal File" do
  block do
    if not ::File.exist?('/etc/apache2/apache2.conf.orig')
     :: FileUtils.cp '/etc/apache2/apache2.conf', '/etc/apache2/apache2.conf.orig'
    end
  end
action :run 
end


#The action :nothing directive means the resource will wait to be called on. a2enmod enables specified mpm module. a2dismod disables specified mpm module. a2ensite enables specified site. a2dissite disables specified site.
execute "enable-event" do
  command "a2dismod mpm_prefork"
  command "a2dismod mpm_work"
  command "a2enmod mpm_event"
  command "a2dissite 000-default"
  action :nothing
end


#Because the MPM needs to be re-enabled, after mpm_event file update, in order to use the new configuration option, we should use the notifies command again, to execute a2enmod mpm_event.
cookbook_file "/etc/apache2/mods-available/mpm_event.conf" do
  source "mpm_event.conf"
  mode "0644"
  notifies :run, "execute[enable-event]"
end


#For each site (vhost) defined in attributes file, create the site config (vhost.conf). Looping tutorial here https://www.kjbweb.net/looping-through-attributes-in-chef/
node['lamp']['web']['site'].each do |sitename, data|
  template "/etc/apache2/sites-available/#{sitename}.conf" do
    source 'multihostdynamic.conf.erb'
    mode '0644'
    variables(
      :document_root => "#{node['lamp']['web']['vhost_document_root']}/#{sitename}",
      :port => data['port'],
      :serveradmin => data['serveradmin']
    )
  end
  execute "enable_vhost_#{sitename}" do
    command "a2ensite #{sitename}"
    not_if ::File.exist?('/etc/apache2/sites-available/#{sitename}.conf')
  end
end


#set phpinfo.php from templates, as landing page (document root).
node['lamp']['web']['site'].each do |sitename, data|
  template "#{node['lamp']['web']['vhost_document_root']}/#{sitename}/public_html/phpinfo.php" do
    source 'phpinfo.php.erb'
    mode '0644'
  end
end


#restart apache to apply the new configuration.
service "apache2" do
  action [:restart]
end

