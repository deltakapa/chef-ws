template '/etc/motd' do
   source 'motd.txt.erb' 
   owner 'root'
   group 'root'
   mode '0755'
end
