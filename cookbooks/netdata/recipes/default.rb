#
# Cookbook:: netdata
# Recipe:: default
#
# Copyright:: 2018, DeltaKapa, All Rights Reserved.

#download_file variable stores the complete URL including the file name for download & install dir defines where app will be installed. Both variables use values from the attribute values defined in attributes file. 
fileurl="#{node[:netdata][:download_url]}"
temp_dir="#{node[:netdata][:tmp_dir]}" 
zipfile="netdata-master.zip" 

#run system updates
execute "update" do
  command "apt-get update -y"
  action :run
end

#install unzip, we will need it later.
package "unzip" do
  action :install
end

#“remote_file” resource is the chef resource which is used to retrieve remote files. The name passed to the remote_file resource is the destination where the remote file need to be stored and in this case is the temporary cache directory used by Chef (Generally it will be something like /var/chef/cache). The download will take place  only if the file is not already available in the cache thus preventing unnecessary download.
remote_file "#{Chef::Config['file_cache_path']}/#{zipfile}" do
  source fileurl
  action :create_if_missing
  mode "0644"
end

#unzip file downloaded from git, to install_dir defined above
execute "unzip" do
  user "root"
  group "root"
  cwd temp_dir
  action :run
#files in the .zip archives use Windows-style line terminators, you will need to pass the -a option to unzip in order to extract them with UNIX-style line terminators (also needed for Mac OS X)
  command "unzip -a #{Chef::Config['file_cache_path']}/#{zipfile}"
  not_if{ ::File.directory?("#{temp_dir}/netdata-master")}
end
