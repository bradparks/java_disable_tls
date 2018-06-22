#!/usr/bin/env bash

me=$(basename "$0")

die()
{
  echo "$*"
  exit;
}

# Get server to test, and timeout in seconds
server="$1"
server_type=${2:-"https"}
timeout_in_seconds=${3:-20}
case "$timeout_in_seconds" in
  ''|*[!0-9]*) die "Your timeout value should be an integer value, not '$3'"
esac

# Should we log full responses?
should_dump_full_responses=${5:-YES}
dump_dir="/tmp/__dump_tls"
mkdir -p "$dump_dir"
dump_file="$dump_dir/$server"
if [ "$should_dump_full_responses" != "YES" ]
then
  rm -f "$dump_file"
fi

show_help()
{
  info=$(cat <<EOF

 $me: 
   Test a domain to see which versions of TLS it supports

 usage: 
   $me SERVER {SERVER_TYPE} {TIMEOUT_IN_SECONDS} {DUMP_FULL_RESPONSES_TO_TMP_FILE}

 e.g.  The following are public test servers that demonstrate support for various TLS versions.

   # Find out what versions of TLS are running on some https servers
   $ $me tls1test.salesforce.com       # validate TLS 1.0 is blocked
   $ $me tls-v1-0.badssl.com:1010      # validate only TLS 1.0 enabled
   $ $me tls-v1-1.badssl.com:1011      # validate only TLS 1.1 enabled
   $ $me smtp.gmail.com:465            # Test smtp at gmail 

   # Find out what versions of TLS are running on some other types of servers
   # by passing in a 'server type'
   $ $me ftp.ssc.church:21  ftp        # Test ftp 

 Note: default timeout in seconds is 20, and it dumps full output to $dump_file

 Other optional arguments:
   TIMEOUT_IN_SECONDS  -> 20 seconds by default. This is only used if you have the 'timeout' command on your path.
   SERVER_TYPE         -> https|ftp|smtp|pop3|imap|xmpp|telnet|ldap|postgres|mysql

EOF
  )
  echo "$info"
  exit
}

if [ -z "$server" ]; then
  show_help
fi

testTLS()
{
  # add optional timeout if timeout command found
  HAS_TESTSSL=$(command -v testssl.sh)
  if [ -z "$HAS_TESTSSL" ]; then
    die "testssl.sh not found -> please 'brew install testssl', then try again"
  fi

  echo
  echo "Processing... This will take ~ 30 seconds to complete."
  echo
  echo " If it takes over a minute, the server isn't responding"
  echo " and you may need to pass in a 'server_type'. "
  echo " See the help for more details."
  echo

  # build a command to run against testssl.sh
  CMD='testssl.sh --color=0 --protocols --warnings batch --quiet --fast '
  if [ "$server_type" = "https" ]; then
    OPT=""
  else
    OPT=" --starttls $server_type"
  fi

  # add optional timeout if timeout command found
  HAS_TIMEOUT=$(command -v timeout)
  if [ -z "$HAS_TIMEOUT" ]; then
    FULL_CMD="$CMD $OPT $server"
  else
    FULL_CMD="$CMD --openssl-timeout $timeout_in_seconds $OPT $server"
  fi

  OUT=$($FULL_CMD 2>&1)

  # Filter our results down to TLS only messages, and show results
  IT=$(echo "$OUT" | grep TLS | grep -v STARTTLS | sed s/offered/supported/g | sort | uniq)
  echo "$IT"

  # Show help if any errors have occurred
  ERR_MSG=" No TLS response received?\n This may mean the server isn't an '$server_type' server.\n Pass in an appropriate 'server type' to test it correctly."
  if [[ $IT = *"doesn't seem to be a TLS"* ]]; then
    echo -e "$ERR_MSG"
    echo
    read -r -p " Press any key for more information."
    show_help
  fi
  if [[ $OUT = *"atal error"* ]]; then
    echo -e "$ERR_MSG"
    echo
    read -r -p " Press any key for more information."
    show_help
  fi
  OUT_TIMEOUT=$(echo "$OUT" | grep "onnection timed out after")
  if [ -n "$OUT_TIMEOUT" ]; then
    die "connection to $server timed out after $timeout_in_seconds seconds"
  fi

  # Save full command and response to a file if required
  if [ "$should_dump_full_responses" == "YES" ]
  then
    echo 
    echo "Saved full dump of request to $dump_file"

    {
      echo "$FULL_CMD"
      echo 
      echo "#######################################"
      echo "$OUT"
      echo 
      echo "$IT"
      echo 
    } >> "$dump_file"
  fi
}

testTLS
