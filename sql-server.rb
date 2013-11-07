#!/usr/bin/env ruby
require_relative 'conf'
require 'mysql2'

class SqlServer
  attr_reader :records
  def initialize(ip)
    client = Mysql2::Client.new(
      :host => ip,
      :username => $username,
      :password => $password,
      :database => $database
    )
    @result = client.query(
      "SELECT * FROM #{$table} 
      WHERE om_id in ( #{$song_omids} )" 
    )
    @records = {}
    @result.each {|e| @records[e.delete("om_id")] = e }
  end
=begin
  def omids
    @omids = @records.keys
    return @omids 
    #@omids = []
    #@records.each_key { |k| @omids << k }
  end
  def fields
    @fields = @records.values[0].keys
    return @fields
  end
=end
end


=begin
def sqlserver(ip)
  client = Mysql2::Client.new(
    :host => ip,
    :username => $username,
    :password => $password,
    :database => $database
  )
  result = client.query(
    "SELECT * FROM #{$table} 
      WHERE om_id in ( #{$song_omids} )" 
  )
  records = {}
  result.each {|e| records[e.delete("om_id")] = e }
  return records
end
=end

=begin
sql_slave = SqlServer.new($ip_slave)
puts '++++++++++++++++++++'
puts sql_slave.records.inspect
puts '++++++++++++++++++++'
puts sql_slave.omids.inspect
puts '++++++++++++++++++++'
puts sql_slave.fields.inspect
=end
