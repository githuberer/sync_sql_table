#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'
require_relative 'conf'
require_relative 'sql-process'

sql = SqlProcess.new($ip_master, $ip_slave)
files = sql.file_to_sync
#files = [ "/file/test/test/test.mp3", "/file/test/test/test.mp4", "/file/test/test/test.mp5" ]
#puts files.inspect

puts <<-header
  \n\nSYNC FILE:
  ***********************************
header

bashcodes = []
#files.each

=begin
Net::SSH.start(
  $ip_file, 
  $ssh_user, 
  :password => $ssh_pass, 
  :port => $ssh_port
) do |ssh|

  files.each do |e|

    bashcodes = <<-header
    /u/shscript/scp_file_mc_or_music.sh #{e} 2>&1
    header

    result = ssh.exec!("#{bashcodes}")

    puts <<-header
      ================
      #{result}
    header
  end
end
=end

