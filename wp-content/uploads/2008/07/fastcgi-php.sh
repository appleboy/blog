#!/bin/sh
#  FreeBSD rc.d script for fastcgi+php
#  in rc.conf
# fcgiphp_enable (bool):	Set it to "YES" to enable fastcgi+php
#				Default is "NO".
# other options see below
#

. /etc/rc.subr

name="fcgiphp"
rcvar=`set_rcvar`

load_rc_config $name

: ${fcgiphp_enable="NO"}
: ${fcgiphp_bin_path="/usr/local/bin/php"}
: ${fcgiphp_user="www"}
: ${fcgiphp_group="www"}
: ${fcgiphp_children="10"}
: ${fcgiphp_port="8002"}
: ${fcgiphp_socket="/tmp/php-fastcgi.sock"}
: ${fcgiphp_env="SHELL PATH USER"}
: ${fcgiphp_max_requests="500"}
: ${fcgiphp_addr="localhost"}


pidfile=/var/run/fcgiphp/fcgiphp.pid
procname="${fcgiphp_bin_path}"
command_args="/usr/local/bin/spawn-fcgi 2> /dev/null -f ${fcgiphp_bin_path} -u ${fcgiphp_user} -g ${fcgiphp_group} -C ${fcgiphp_children} -P ${pidfile}"
start_precmd=start_precmd
stop_postcmd=stop_postcmd

start_precmd()
{
  PHP_FCGI_MAX_REQUESTS="${fcgiphp_max_requests}"
  FCGI_WEB_SERVER_ADDRS=$fcgiphp_addr
  export PHP_FCGI_MAX_REQUESTS
  export FCGI_WEB_SERVER_ADDRS
  allowed_env="${fcgiphp_env} PHP_FCGI_MAX_REQUESTS FCGI_WEB_SERVER_ADDRS"
# copy the allowed environment variables
  E=""
  for i in $allowed_env; do
    eval "x=\$$i"
    E="$E $i=$x"
  done
  command="env - $E"

  if [ -n "${fcgiphp_socket}" ]; then
    command_args="${command_args} -s ${fcgiphp_socket}"
  elif [ -n "${fcgiphp_port}" ]; then
    command_args="${command_args} -p ${fcgiphp_port}"
  else
    echo "socket or port must be specified!"
    exit
  fi
}

stop_postcmd()
{
  rm -f ${pidfile}
#	eval "ipcs | awk '{ if (\$5 == \"${fcgiphp_user}\") print \"ipcrm -s \"\$2}' | /bin/sh"
}

run_rc_command "$1"


