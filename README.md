# tcping

tcping isn't like normal tcping, and written with Swift.

# Usage
```
➜ tcping --help
tcping is a ping over tcp connection.

Examples:
    1. ping over tcp with custom port 10 times
       > tcping www.baidu.com 80
    2. ping over tcp with custom port 5 times
       > tcping -c 5 www.baidu.com 443

USAGE: tcping [--count <count>] <ip> <port>

ARGUMENTS:
  <ip>                    The IP or Domain to tcping.
  <port>                  The port to tcping.

OPTIONS:
  -c, --count <count>     The number of times to repeat 'tcping'. Default value is 10, Max value is 65535
  -h, --help              Show help information.
```

# Examples
baidu.com
```
➜ tcping -c 5 baidu.com 443
baidu.com:443 has address: (39.156.69.79:443) - Connected - 52.651ms
baidu.com:443 has address: (39.156.69.79:443) - Connected - 50.82ms
baidu.com:443 has address: (39.156.69.79:443) - Connected - 53.418ms
baidu.com:443 has address: (39.156.69.79:443) - Connected - 51.475ms
baidu.com:443 has address: (39.156.69.79:443) - Connected - 48.006ms
Ping statistics baidu.com:443
    5 probes sent.
    5 successful, 0 failed.
Approximate trip times:
    Minimum = 48.006ms, Maximum = 53.418ms, Average = 51.274ms
```

with ip
```
➜ tcping -c 5 39.156.69.79 443
39.156.69.79:443 - Connected - 59.852ms
39.156.69.79:443 - Connected - 50.307ms
39.156.69.79:443 - Connected - 50.308ms
39.156.69.79:443 - Connected - 49.254ms
39.156.69.79:443 - Connected - 50.308ms
Ping statistics 39.156.69.79:443
    5 probes sent.
    5 successful, 0 failed.
Approximate trip times:
    Minimum = 49.254ms, Maximum = 59.852ms, Average = 52.006ms
```
