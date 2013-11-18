#!/usr/bin/env ruby
require 'cgi'
require 'erb'



# test

logfile = "/var/log/cgi-bin/sync_mc_or_music.log"

lists = CGI.new['lists'].split("\s").select { |e| e =~ /^\d*$/ }.join(" ")

result_shellcodes = %x[ ./main.sh '#{lists}' 2>&1 | tee #{logfile} ]



sources_lists =%{

Sync SQL(om_id) & FILES: 
**************************************************************
<%= lists %>




RESULTS :
**************************************************************
<%= result_shellcodes%>

}


puts ERB.new(sources_lists).result(binding)



=begin

shellcodes = <<-header
  ./main.sh '#{lists}' 2>&1
header


pid = spawn(
  "#{shellcodes}", 
  :out => "#{logfile}",
  :err => "#{logfile}"
)
Process.detach(pid)


sources_lists =%{

  Sync message:

  ==============================
  "Synchronization processed background......"
  ==============================


  ==============================
  Please go back to chklog.
  ==============================


  ==============================
  sql_om_id : <%= lists %>
  ==============================
}

puts ERB.new(sources_lists).result(binding)
=end




