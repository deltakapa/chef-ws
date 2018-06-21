#
# Cookbook:: lamp
# Recipe:: mysql
#
# Copyright:: 2018, The Authors, All Rights Reserved.


#load MySQL passwords from the 'passwords' data bag.
dbcredentials = data_bag_item('mysql', 'dbadminpass')

# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password dbcredentials['root_password']
  action [:create, :start]
end

#Install the mysql2 Ruby gem.
mysql2_chef_gem 'default' do
  action :install
end

mysql_connection_info = {
  host: '127.0.0.1',
  username: 'root',
  password: dbcredentials['root_password'],
}

# Create the database instance.
mysql_database node['lamp']['db']['dbname'] do
  connection mysql_connection_info
  action :create
end

# Add a database user. Get details from cookbooks/lamp/attributes/default.rb
mysql_database_user node['lamp']['db']['admin_user'] do
  connection mysql_connection_info
  password dbcredentials['password']
  database_name node['lamp']['db']['dbname']
  host '127.0.0.1'
  action [:create, :grant]
end
