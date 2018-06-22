# TLS Tester

This script helps you test a domain to see which versions of TLS it supports.

## Install some dependencies

`brew install testssl`

or if you're on another platform, you can [follow the install instructions here](https://testssl.sh/)

## How to run it
After that's complete, you can simply run the `test_tls.sh` script in this repo.

For example:

```
$ ./test_tls.sh tls1test.salesforce.com       

Processing... This may take up to 20 seconds to complete.

 TLS 1      not supported
 TLS 1.1    supported
 TLS 1.2    supported (OK)
```

Run it with no arguments to see additional options. Note if you're testing
anything that isn't an https:// server, you'll probably need to pass in the
server type. 

For example, if you're testing a secure FTP server (SFTP), you'd run it like so:

```
$ ./test_tls.sh ftp.ssc.church:21 ftp 

Processing... This may take up to 20 seconds to complete.

 TLS 1      not supported
 TLS 1.1    supported
 TLS 1.2    supported (OK)
```
