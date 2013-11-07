#!/usr/bin/env ruby
require 'cgi'
require 'erb'


lists = CGI.new['lists'].split("\s").select { |e| e =~ /^\d*$/ }.join(" ")


shellcodes = <<-header
  ./main.sh '#{lists}'
header

result_shellcodes = %x[ #{shellcodes} ]

sources_lists =%{

  Sync message:


  ==============================
  <%= result_shellcodes %>
  ==============================


  ==============================
  Please go back to chklog.
  ==============================


  ==============================
  sql_om_id : <%= lists %>
  ==============================

}
puts ERB.new(sources_lists).result(binding)


