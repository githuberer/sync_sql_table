#!/usr/bin/env ruby
require_relative 'sql-server'
require_relative 'conf'

class SqlProcess
  attr_reader :master_records, :slave_records

  def initialize(ip_master, ip_slave)
    #@master_sql = SqlServer.new(ip_master)
    #@slave_sql = SqlServer.new(ip_slave)
    #@master_records = @master_sql.records
    #@slave_records = @slave_sql.records
    @master_records = SqlServer.new(ip_master).records
    @slave_records = SqlServer.new(ip_slave).records
  end

  def records_to_insert
    @records_to_insert = Marshal.load(
      Marshal.dump(@master_records)
    ).reject { |k, v| @slave_records.has_key?(k) }

    @records_to_insert.each do |k1, v1|
      v1.each do |k2, v2|
        if v2.nil?
        v1[k2] = "NULL"
        else
          v1[k2] = "'#{v2}'"
        end
      end
    end
    return @records_to_insert
  end

  def records_to_update
    @records_to_update = Marshal.load(
      Marshal.dump(@master_records) 
    ).select { |k, v| @slave_records.has_key?(k) }

    @records_to_update.each do |k1 ,v1|
      v1.delete_if do |k2, v2|
        v2 == @slave_records[k1][k2]
      end
    end
    @records_to_update.delete_if { |k, v| v.empty? }

    @records_to_update.each do |k1, v1|
      v1.each do |k2, v2|
        if v2.nil?
        v1[k2] = "NULL"
        else
          v1[k2] = "'#{v2}'"
        end
      end
    end
    return @records_to_update
  end

  def file_to_sync
    @files = []
    Marshal.load( Marshal.dump(@master_records) ).each_value do |v|
      $fields_filepath.each do |f|
        @files << v[f] unless v[f].nil?
      end
    end
    return @files
  end

end


=begin
sql = SqlProcess.new($ip_master, $ip_slave)
puts sql.file_to_sync
puts sql.records_to_insert.inspect
puts sql.records_to_update.inspect
=end

