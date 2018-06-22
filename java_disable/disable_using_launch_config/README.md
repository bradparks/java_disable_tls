# Disable TLSv1 using launch config
- This sample shows how to disable TLSv1 via JVM launch configuration
- Just run `./run_me.sh` and it'll show you how changing this value affects connecting to a site that doesnt support TLSv1.
- In short, to disable using launch config, run your java app like so:

    ```
    java -Djava.security.properties=disabled_tlsv1.properties
    ```

where [disabled_tlsv1.properties](../data/disabled_tlsv1.properties) is a list of the insecure ciphers to disable.
