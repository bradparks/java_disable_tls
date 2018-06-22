# TLS CSV

This script helps you test a series of websites for TLS support, and shows if TLS support has changed from the results stored in the input data CSV file.

## Install some dependencies

`npm install`

## How to run it
After that's complete, you can simply run the `./test_csv` script in this folder.

For example:

```
$ ./test_csv 
```

Run the following for additional options and examples

```
$ ./test_csv --help
```

## How are we using this script? 

We're using it to see if TLS support has changed for certain servers.

Simply running

```
$ ./test_csv -d
```

will show you a list of servers that have changed their TLS support.

