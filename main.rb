#!/usr/bin/env ruby
require 'cgi'
require 'erb'


lists = CGI.new['lists'].split("\s").select { |e| e =~ /^\d*$/ }.join(" ")

shellcodes = <<-header
  ./main.sh '#{lists}'
header

result_shellcodes = %x[ #{shellcodes} ]
puts result_shellcodes

sources_lists =%{
  <%= result_shellcodes %>

  om_id: 
  ====================
  <%= lists %>
}

puts ERB.new(sources_lists).result(binding)

=begin
shellcodes = <<-header
. /home/wyy/bash_functions/script-variable.sh
if flock -n 9
then
  (
    func_tmstamp
    echo "#{lists}" > lists.conf &&\
    (./sync-sql.rb && ./sync-file.rb)
  ) 9> /var/lock/cgi-bin/ShellcodesMainRb.lock
else
  echo "Sync is in processing,now...Please try again later......"
fi
header

pid = spawn(
  "#{shellcodes}", 
  :out => "/var/log/cgi-bin/sync_mc_or_music.log", 
  :err => "/var/log/cgi-bin/sync_mc_or_music.log", 
)
Process.detach(pid)
=end


=begin
value = <<-header
#{CGI.new['lists']}
header

SOURCE =%{
<% value.each_line do |e| %>
pid: <%= pid %>
result is <%= e %>
<% end %>
}

#erb = ERB.new(SOURCE)
#puts erb.result(binding)
puts ERB.new(SOURCE).result(binding)
=end

