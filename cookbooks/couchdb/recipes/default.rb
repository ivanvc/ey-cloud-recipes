#
# Cookbook Name:: couchdb
# Recipe:: default
#

package "couchdb" do
  version "0.9.0"
end

directory "/db/couchdb/log" do
  owner "couchdb"
  group "couchdb"
  mode 0755
  recursive true
end

template "/etc/couchdb/default.ini" do
  owner 'root'
  group 'root'
  mode 0644
  source "default.ini.erb"
  variables({
    :basedir => '/db/couchdb',
    :logfile => '/db/couchdb/log/couch.log',
    :bind_address => '127.0.0.1', # '0.0.0.0' if you want couch available to the outside world
    :port  => '5984',# change if you want to listen on another port
    :doc_root => '/usr/share/couchdb/www', # change if you have a cutom couch www root
    :driver_dir => '/usr/lib/couchdb/erlang/lib/couch-0.9.0/priv/lib', # this is good for the 0.8.1 build on our gentoo
    :loglevel => 'info'
  })
end

remote_file "/etc/init.d/couchdb" do
  source "couchdb"
  owner "root"
  group "root"
  mode 0755
end

service "couchdb" do
  start_command "/etc/init.d/couchdb start &> /dev/null"
  stop_command "/etc/init.d/couchdb stop &> /dev/null"
  supports [ :restart, :status ]
  action [ :enable, :start ]
end