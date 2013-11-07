#!/usr/bin/env bash

lists=$1
rbdir=$(dirname $(realpath $0))
logfile=/var/log/cgi-bin/sync_mc_or_music.log
lockfile=/var/lock/cgi-bin/shellcodesMainrb.lock

func_tmstamp()
{
  echo "
===========================
$(date +%Y-%m-%d_%H:%M)
==========================="
}

func_ruby()
{
  func_tmstamp
  if echo $lists > $rbdir/lists.conf
  then
    $rbdir/sync-sql.rb && $rbdir/sync-file.rb
  fi
}

if [[ $# == 1 && $lists =~ [0-9]+ ]]
then
  (
    if flock -n 9
    then
      echo "Synchronization is processing background......"
      (func_ruby &> $logfile)&
    else
      echo "Error: Last sync Hasn't done...try again later......"
    fi
  ) 9> $lockfile
else
  echo -e "\n USAGE EXAMPLE: ${0##*/} '1 2 3 4' \n"
fi
