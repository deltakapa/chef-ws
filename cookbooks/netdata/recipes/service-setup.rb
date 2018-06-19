#
# Cookbook:: netdata
# Recipe:: Service Configuration
#
# Copyright:: 2018, DeltaKapa, All Rights Reserved.

#download_file variable stores the complete URL including the file name for download & install dir defines where app will be installed. Both variables use values from the attribute values defined in attributes file. 
fileurl="#{node[:netdata][:download_url]}"
install_dir="#{node[:netdata][:install_dir]}" 
cronfile="/var/spool/cron/crontabs/root"

#set netdata service to turn on at reboot, and start.
service "netdata" do
  action [:enable, :start]
end

#add a cron-job at the bottom to try and update netdata every day at 10:00AM
ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("#{cronfile}")
    file.insert_line_if_no_match("netdata-updater.sh", "0 10 * * * /path/to/git/downloaded/netdata/netdata-updater.sh")
    file.write_file
  end
end
