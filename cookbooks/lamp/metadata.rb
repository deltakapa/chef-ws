name 'lamp'
maintainer 'Delta Kapa'
maintainer_email 'dimiak_@hotmail.com'
license 'All Rights Reserved'
description 'Installs/Configures lamp'
long_description 'Installs/Configures lamp'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

# In order to load one cookbook from inside another is to reference it in your cook
#depends 'mysql', '~> 6.0'
#depends 'apache2'
depends 'mysql'
depends 'mysql2_chef_gem'
depends 'database'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/lamp/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/lamp'
