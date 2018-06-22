#!/usr/bin/env bash

#set -x 

rm -f log.txt

ENABLED_PROTOCOLS_ALL="SSLv3,TLSv1,TLSv1.1,TLSv1.2,SSLv2Hello"
ENABLED_PROTOCOLS_ONLY_TLSV1="TLSv1"
ENABLED_PROTOCOLS_ONLY_SSLV3="SSLv3"
ENABLED_PROTOCOLS_BEST="TLSv1.1,TLSv1.2"

function test()
{
  PROTOCOLS="$1"
  STATE="$2"
  EXPECTED_RESULT="$3"
  PROPS="$4"
  echo "#############################################################################"
  echo "Connecting to $DOMAIN using alg: $PROPS"
  echo "using Java and $STATE. Expected result: $EXPECTED_RESULT"
  CMD="java  \
    -Djdk.tls.client.protocols="$PROTOCOLS"  \
    -Djava.security.properties="../data/${PROPS}" \
    -Djavax.net.debug=sslctx,handshake  \
    TestOutboundConnection "$DOMAIN" 1 2>&1 "
  IT=$(eval "$CMD")
  OUTPUT=$(echo "$IT" | grep handshake_failure)
  echo "$CMD" >> log.txt

  if [ -z "$OUTPUT" ]
  then
    RESULT="SUCCESS"
  else
    RESULT="FAIL"
  fi

  if [ "$RESULT" == "$EXPECTED_RESULT" ]
  then
    echo "TEST PASSED!"
  else
    echo "  #######################"
    echo "  ##### TEST FAILED #####"
    echo "  #######################"
  fi

  echo 
}

echo "This test validates that ciphers in java can be disabled at the command line."
echo "It does this by making requests to 2 different https servers"
echo "One that has TLSv1 disabled, and one that supports all versions of TLS"
echo "It then tries each of these servers with ciphers enabled/disabled via command line."
echo
read -rp "Press any key to continue"

javac TestOutboundConnection.java > /dev/null 2>&1

# Run a bunch of tests against t.co, which has all TLS versions enabled
DOMAIN="https://t.co"
PROPS_FILE='disabled_tlsv1'
test "$ENABLED_PROTOCOLS_ALL" "ALL PROTOCOLS ENABLED, even TLSv1" "SUCCESS" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_ONLY_TLSV1" "TLSv1 only allowed" "SUCCESS" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_ONLY_SSLV3" "SSLv3 only allowed" "FAIL" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_BEST" "TLSv1 disabled" "SUCCESS" "$PROPS_FILE"
PROPS_FILE='disabled_default'
test "$ENABLED_PROTOCOLS_ALL" "ALL PROTOCOLS ENABLED, even TLSv1" "SUCCESS" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_ONLY_TLSV1" "TLSv1 only allowed" "SUCCESS" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_ONLY_SSLV3" "SSLv3 only allowed" "FAIL" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_BEST" "TLSv1 disabled" "SUCCESS" "$PROPS_FILE"

# Run a bunch of tests against a salesforce site that's got TLSv1 disabled
DOMAIN='https://tls1test.salesforce.com'
PROPS_FILE='disabled_tlsv1'
test "$ENABLED_PROTOCOLS_ALL" "ALL PROTOCOLS ENABLED, even TLSv1" "SUCCESS" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_ONLY_TLSV1" "TLSv1 only allowed" "FAIL" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_ONLY_SSLV3" "SSLv3 only allowed" "FAIL" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_BEST" "TLSv1 disabled" "SUCCESS" "$PROPS_FILE"
PROPS_FILE='disabled_default'
test "$ENABLED_PROTOCOLS_ALL" "ALL PROTOCOLS ENABLED, even TLSv1" "SUCCESS" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_ONLY_TLSV1" "TLSv1 only allowed" "FAIL" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_ONLY_SSLV3" "SSLv3 only allowed" "FAIL" "$PROPS_FILE"
test "$ENABLED_PROTOCOLS_BEST" "TLSv1 disabled" "SUCCESS" "$PROPS_FILE"

rm -f *.class

echo "Commands saved in log.txt"
