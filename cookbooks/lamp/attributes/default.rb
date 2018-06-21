#Document Root Definition
default['lamp']['web']['document_root'] = '/var/www/default/public_html'
default['lamp']['web']['vhost_document_root'] = '/var/www/default'

#Vhost Definition
default['lamp']['web']['site']['example1'] = { 'port' => '80',  'serveradmin' => 'deltakapa@webmaster' }
default['lamp']['web']['site']['example2'] = { 'port' => '80',  'serveradmin' => 'deltakapa@webmaster' }

#DB Instance Definition
default['lamp']['db']['dbname'] = 'master'
default['lamp']['db']['admin_user'] = 'dbadmin'
