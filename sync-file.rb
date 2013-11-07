#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'
require_relative 'conf'
require_relative 'sql-process'

sql = SqlProcess.new($ip_master, $ip_slave)
#files = sql.file_to_sync
files = [ "/file/test/test/test.mp3", "/file/test/test/test.mp4", "/file/test/test/test.mp5" ]
#puts files.inspect

puts <<-header
  \n\nSYNC FILE:
  ###################################
header


Net::SSH.start(
  $ip_file, 
  $ssh_user, 
  :password => $ssh_pass, 
  :port => $ssh_port
) do |ssh|

  files.each do |e|
    bashcodes = <<-header
      LANG="en_US.UTF-8"
      file=/u/mfs#{e}
      ( [[ ! -d ${file%/*} ]] && sudo -u #{file_user} mkdir -p ${file%/*} )
      sudo scp #{$ip_master}:$file $file &&\
      ( sudo chown #{file_user}.#{file_group} $file; sudo ls -l $file ) 
    header
    result = ssh.exec!("#{bashcodes}")
    puts <<-header
      ================
      #{result}
    header
  end
end



=begin
bashcodes = <<-header
LANG="en_US.UTF-8"
lists="#{files.join(" ")}"
for l in ${lists}
do
  file=/u/mfs${l}
  [[ ! -d ${file%/*} ]] && sudo -u v5 mkdir -p ${file%/*}
  sudo scp v5backup:$file $file && sudo chown v5.app $file
  sudo ls -l $file
  sudo ls -ld ${file%/*}
  echo "#############"
done
header

puts <<-header
\n\n===Bash_script===
#{bashcodes}
\n\n===Result===
header

Net::SSH.start(
  $ip_file, 
  $ssh_user, 
  :password => $ssh_pass, 
  :port => $ssh_port
) do |ssh|
  result = ssh.exec!("#{bashcodes}")
  puts result
end
=end
