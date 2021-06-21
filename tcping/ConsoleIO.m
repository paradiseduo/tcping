//
//  ConsoleIO.m
//  tcping
//
//  Created by ParadiseDuo on 2020/5/11.
//  Copyright © 2020 MacClient. All rights reserved.
//

#import "ConsoleIO.h"
#import "Version.h"

@implementation ConsoleIO
+ (void)writeMessage:(NSString *)message to:(NSInteger)to {
    switch (to) {
        case OutputTypeError:
            NSLog(@"%@", message);
            break;
        default:
            fputs(message.UTF8String, stderr);
            break;
    }
}

+ (void)printUsage {
   
    NSString * v = @""
"\n      dP                     oo"
"\n      88"
"\n    d8888P .d8888b. 88d888b. dP 88d888b. .d8888b.    {Version: %@}"
"\n      88   88       88    88 88 88    88 88    88"
"\n      88   88.      88.  .88 88 88    88 88.  .88"
"\n      dP   `88888P  88Y888P  dP dP    dP `8888P88"
"\n                    88                        .88"
"\n                    dP                    d8888P"
"\n"
"\ntcping is a ping over tcp connection.\n"
"\n"
"Examples:\n\
    1. ping over tcp with custom port 10 times\n\
        > tcping www.baidu.com 80\n\
    2. ping over tcp with custom port 5 times\n\
        > tcping -c 5 www.baidu.com 443\n\
\n\
USAGE: tcping [--count <count>] <ip> <port>\n\
\n\
ARGUMENTS:\n\
    <ip>                    The IP or Domain to tcping.\n\
    <port>                  The port to tcping.\n\
\n\
OPTIONS:\n\
    -c, --count <count>     The number of times to repeat 'tcping'. Default value is 10, Max value is 65535\n\
    -h, --help              Show help information.\n";
    
    NSString * verbose = [NSString stringWithFormat:v, VERSION];
    [ConsoleIO writeMessage:verbose to:OutputTypeStandard];
}

+ (void)printReulst:(BOOL)isFinish detail:(Tcping *)detail count:(NSUInteger)count lossCount:(NSUInteger)lossCount min:(NSNumber *)min max:(NSNumber *)max avge:(NSNumber *)avge {
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    nf.maximumFractionDigits = 3;
    
    if (isFinish) {
        [ConsoleIO writeMessage:[NSString stringWithFormat:@"Ping statistics %@:%u\n", detail.domain, detail.port] to:OutputTypeStandard];
        [ConsoleIO writeMessage:[NSString stringWithFormat:@"    %lu probes sent.\n", count] to:OutputTypeStandard];
        [ConsoleIO writeMessage:[NSString stringWithFormat:@"    %lu successful, %lu failed.\n", count-lossCount, lossCount] to:OutputTypeStandard];
        [ConsoleIO writeMessage:@"Approximate trip times:\n" to:OutputTypeStandard];
        [ConsoleIO writeMessage:[NSString stringWithFormat:@"    Minimum = %@ms, Maximum = %@ms, Average = %@ms\n", [nf stringFromNumber:min], [nf stringFromNumber:max], [nf stringFromNumber:avge]] to:OutputTypeStandard];
    } else {
        if ([detail.host isEqualToString:detail.domain]) {
            [ConsoleIO writeMessage:[NSString stringWithFormat:@"%@:%u - Connected - %@ms\n", detail.host, detail.port, [nf stringFromNumber:[NSNumber numberWithDouble:detail.speed]]] to:OutputTypeStandard];
        } else {
            [ConsoleIO writeMessage:[NSString stringWithFormat:@"%@:%u has address: %@:%u - Connected - %@ms\n", detail.domain, detail.port, detail.host, detail.port, [nf stringFromNumber:[NSNumber numberWithDouble:detail.speed]]] to:OutputTypeStandard];
        }
    }
}
@end
