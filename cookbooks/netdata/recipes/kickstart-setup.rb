#
# Cookbook:: netdata
# Recipe:: default
#
# Copyright:: 2018, DeltaKapa, All Rights Reserved.

#download_file variable stores the complete URL including the file name for download & install dir defines where app will be installed. Both variables use values from the attribute values defined in attributes file. 
fileurl="#{node[:netdata][:download_url]}"
install_dir="#{node[:netdata][:install_dir]}" 


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
bash 'kickstart-install-netdata' do
  user "root"
  group "root"
  cwd install_dir
  code <<-EOF
    curl #{fileurl} >/tmp/kickstart-static64.sh
    sh /tmp/kickstart-static64.sh --dont-wait --dont-start-it
  EOF
  not_if{ ::File.directory?("#{install_dir}/netdata")}
end
