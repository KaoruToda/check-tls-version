# check-tls-version

This is NSE script for Nmap.
check-tls-version check tls version.

# How to use

`nmap --script ./check-tls-version.nse localhost -p 443`

# Example of execution

~~~
PORT    STATE SERVICE
443/tcp open  https
| check-tls-version:
|   TLSv1.2: true
|   TLSv1.0: false
|_  TLSv1.1: false
~~~
