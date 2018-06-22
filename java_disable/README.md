# Disable TLSv1 and insecure ciphers in Java
These 2 samples show how to disable TLSv1 and other insecure ciphers in Java

### [disable_using_launch_config](disable_using_launch_config)
- shows how to disable TLSv1 and ciphers using JVM launch config. This is the most flexible approach overall.

### [dump_active_ciphers](dump_active_ciphers)
- shows how TLSv1 and ciphers can be disabled completely at the JVM level, and affects all java applications on a server

