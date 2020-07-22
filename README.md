# tcping

Better than tcping installed by Homebrew👍

Written with Objective-C👍

Support MacOS only👍

# Download & Install
```bash
➜ wget https://github.com/paradiseduo/tcping/releases/download/3.1/tcping.zip
➜ unzip tcping.zip
➜ chmod +x tcping
➜ mv tcping /usr/local/bin/
➜ sudo xattr -rd com.apple.quarantine /usr/local/bin/tcping
```

# Usage
```bash
➜ tcping --help
Version 3.1

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
with domain
```bash
➜ tcping -c 5 baidu.com 443
baidu.com:443 has address: 220.181.38.148:443 - Connected - 32.682ms
baidu.com:443 has address: 220.181.38.148:443 - Connected - 29.372ms
baidu.com:443 has address: 39.156.69.79:443 - Connected - 52.232ms
baidu.com:443 has address: 220.181.38.148:443 - Connected - 28.922ms
baidu.com:443 has address: 220.181.38.148:443 - Connected - 28.975ms
Ping statistics baidu.com:443
    5 probes sent.
    5 successful, 0 failed.
Approximate trip times:
    Minimum = 28.922ms, Maximum = 52.232ms, Average = 34.437ms
```

with ip
```bash
➜ tcping -c 5 220.181.38.148 443
220.181.38.148:443 - Connected - 30.635ms
220.181.38.148:443 - Connected - 30.816ms
220.181.38.148:443 - Connected - 28.708ms
220.181.38.148:443 - Connected - 30.713ms
220.181.38.148:443 - Connected - 34.641ms
Ping statistics 220.181.38.148:443
    5 probes sent.
    5 successful, 0 failed.
Approximate trip times:
    Minimum = 28.708ms, Maximum = 34.641ms, Average = 31.103ms
```
