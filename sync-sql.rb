#!/usr/bin/env ruby

require 'mysql2'
require_relative 'conf'
require_relative 'sql-process'


sql = SqlProcess.new($ip_master, $ip_slave)
insert_value = sql.records_to_insert
update_value = sql.records_to_update
#puts insert_value.inspect
#puts update_value.inspect

sqls_update = []
sqls_insert = []

update_value.each do |k1, v1|
  set_lists = []
  v1.each do |k2, v2|
    set_lists << "#{k2} = #{v2}"
  end
  sqls_update << <<-header
    UPDATE #{$table} SET #{set_lists.join(', ')} WHERE om_id = #{k1}
  header
end

insert_value.each do |k1, v1|
  sqls_insert << <<-header
    INSERT INTO #{$table} (om_id, #{v1.keys.join(', ')}) VALUES ('#{k1}', #{v1.values.join(', ')})
  header
end


puts <<-header
  \n\nSYNC SQL:
  ###################################
header

client = Mysql2::Client.new(
  :host => $ip_slave,
  :username => $username,
  :password => $password,
  :database => $database
)

sqls_update.each do |e|
  result = client.query("#{e}")
  puts <<-header
    ================
    #{e}
    #{result}
  header
end

sqls_insert.each do |e|
  result = client.query("#{e}")
  puts <<-header
    ================
    #{e}
    #{result}
  header
end

