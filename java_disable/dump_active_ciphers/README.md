# Dump Ciphers being used by Java
- This simple sample shows the ciphers that are currently available to Java, and whether or not they're enabled or disabled.
- We'll use this to verify that ciphers that should be disabled have actually been disabled.
- This is managed by dumping the cipher list with and without TLSv1 and insecure ciphers disabled, and comparing the result.
- The java sample was [snagged from here](https://confluence.atlassian.com/stashkb/list-ciphers-used-by-jvm-679609085.html) and slightly modified.

## Dump the ciphers 
- Run `./run_me.sh` and it will dump the list of enabled ciphers to 2 tab files, one with the default config, one with TLSv1 and insecure ciphers disabled.
- The 2 files are in the `../data` folder, `out_default.tab` and `out_tlsv1.tab`

## Verify the ciphers are disabled
- run `npm install` in this folder to setup some tools to do the verification
- You can now verify that by running `node verify_results.js`
- Of course, you can manually compare the `../data/out_default.tab` and `../data/out_tlsv1.tab` files as well.
