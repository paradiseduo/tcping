# tcping

Better than tcping installed by Homebrew👍

Written with Objective-C👍

Support MacOS only👍

## Download & Install
```bash
➜ wget https://github.com/paradiseduo/tcping/releases/download/3.3/tcping.zip
➜ unzip tcping.zip
➜ chmod +x tcping
➜ mv tcping /usr/local/bin/
➜ sudo xattr -rd com.apple.quarantine /usr/local/bin/tcping
```

## Usage
```bash
➜ tcping --help

      dP                     oo
      88
    d8888P .d8888b. 88d888b. dP 88d888b. .d8888b.    {Version: 3.5}
      88   88       88    88 88 88    88 88    88
      88   88.      88.  .88 88 88    88 88.  .88
      dP   `88888P  88Y888P  dP dP    dP `8888P88
                    88                        .88
                    dP                    d8888P

tcping is a ping over tcp connection.

Examples:
    1. ping over tcp with custom port 10 times
        > tcping www.baidu.com 80
    2. ping over tcp with custom port 5 times
        > tcping -c 5 www.baidu.com 443

USAGE: tcping [--count <count>] [--interval <interval>] <ip> <port>

ARGUMENTS:
    <ip>                        The IP or Domain to tcping.
    <port>                      The port to tcping.

OPTIONS:
    -c, --count <count>         The number of times to repeat 'tcping'. Default value is 10, Max value is 65535
    -i, --interval <interval>   The request interval(second). Default value is 1 second
    -h, --help                  Show help information.
```

## Examples
with domain
```bash
❯ tcping -c 5 baidu.com 443
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

with ipv4
```bash
❯ tcping -c 5 220.181.38.148 443
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

with ipv6
```bash
❯ tcping -c 3 ::1 8080                                                                                                                                           
::1:8080 - Connected - 0.502ms
::1:8080 - Connected - 0.432ms
::1:8080 - Connected - 0.752ms
Ping statistics ::1:8080
    3 probes sent.
    3 successful, 0 failed.
Approximate trip times:
    Minimum = 0.432ms, Maximum = 0.752ms, Average = 0.562ms
```

## Star Trend
[![Stargazers over time](https://starchart.cc/paradiseduo/tcping.svg)](https://starchart.cc/paradiseduo/tcping)
