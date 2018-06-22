#!/usr/bin/env bash

if [ -z "$2" ]
  then
    echo "This is an internal script. Read the docs!"
    exit;
fi

#set -x 

OUT_FILE="../data/$1"
DISABLE_PROPERTIES="$2"

javac DumpCiphers.java &> /dev/null
java -Djava.security.properties="../data/$DISABLE_PROPERTIES" DumpCiphers > "$OUT_FILE"

rm -f DumpCiphers.class

echo "Updated file:"
ls -lah "$OUT_FILE"
