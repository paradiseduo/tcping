//
//  tcping.m
//  tcping
//
//  Created by Youssef on 2020/3/25.
//

#import "tcping.h"
#import <arpa/inet.h>
#import <netdb.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <unistd.h>
#include <netinet/in.h>
#include <netinet/tcp.h>

@implementation TcpingDetail

@end

static tcping *g_TCPing = nil;
void tcp_conn_handler()
{
    if (g_TCPing) {
        [g_TCPing processLongConn];
    }
}

@interface tcping(){
    struct sockaddr_in addr;
    int sock;
}
@property (nonatomic, readonly) NSString  * host;
@property (nonatomic, readonly) NSUInteger port;
@property (nonatomic, readonly) NSUInteger count;
@property (copy, readonly) TcpingHandler complete;
@property (copy, readonly) TcpingHandler stepInfo;
@property (atomic) BOOL isStop;
@property (nonatomic) BOOL isSucc;

@property (nonatomic) TcpingDetail * pingDetails;
@end

@implementation tcping
- (instancetype)init:(NSString *)host port:(NSUInteger)port count:(NSUInteger)count stepInfo:(TcpingHandler _Nonnull)step complete:(TcpingHandler)complete {
    if (self = [super init]) {
        _host = host;
        _port = port;
        _count = count;
        _complete = complete;
        _stepInfo = step;
        _isStop = NO;
        _isSucc = YES;
        _pingDetails = [[TcpingDetail alloc] init];
        _pingDetails.port = port;
        _pingDetails.domain = host;
        _pingDetails.count = count;
        NSString * ip = [self convertDomainToIp:host];
        if (ip) {
            _pingDetails.ip = ip;
        } else {
            _pingDetails.ip = @"";
        }
    }
    return self;
}

+ (void)start:(NSString *)host port:(NSUInteger)port count:(NSUInteger)count stepInfo:(TcpingHandler _Nonnull)step complete:(TcpingHandler _Nonnull)complete {
    NSUInteger max = 65535;
    tcping * tcp = [[tcping alloc] init:host port:port count:(count > max ? max : count) stepInfo:step complete:complete];
    g_TCPing = tcp;
    if (![tcp.pingDetails.ip isEqualToString:@""]) {
        [tcp testing];
    }
}

- (void)testing {
    int index = 0;
    int r = 0;
    int loss = 0;
    NSMutableArray<NSNumber *> * intervals = [[NSMutableArray alloc] init];
    while (index < _count && !_isStop &&  r == 0) {
        NSDate *t_begin = [NSDate date];
        r = [self connect:&addr];
        NSTimeInterval conn_time = [[NSDate date] timeIntervalSinceDate:t_begin];
        [intervals addObject:[NSNumber numberWithDouble:conn_time * 1000]];
        if (r == 0) {
            _pingDetails.speed = [NSNumber numberWithDouble:conn_time*1000];
        } else {
            _pingDetails.error = [NSString stringWithFormat:@"Connect failed to %s:%lu",inet_ntoa(addr.sin_addr), (unsigned long)_port];
            loss++;
            _pingDetails.loss = loss;
        }
        _stepInfo(_pingDetails);
        if (index < _count && !_isStop && r == 0) {
            index++;
            usleep(1000*100);
        }
    }
    NSInteger code = r;
    if (_isStop) {
        code = -5;
    }else{
        _isStop = YES;
    }
    
    if (self.isSucc) {
        NSNumber * max = @0.0;
        NSNumber * min = @10000000.0;
        NSTimeInterval sum = 0.0;
        for (int i= 0; i < intervals.count; i++) {
            if (intervals[i].doubleValue > max.doubleValue) {
                max = intervals[i];
            }
            if (intervals[i].doubleValue < min.doubleValue) {
                min = intervals[i];
            }
            sum += intervals[i].doubleValue;
        }
        NSNumber * avg = [NSNumber numberWithDouble:sum/_count];
        _pingDetails.avg_time = avg;
        _pingDetails.max_time = max;
        _pingDetails.min_time = min;
    }
    self.complete(self.pingDetails);
}

- (BOOL)isTcpPing {
    return !_isStop;
}

- (void)stopTcpPing {
    _isStop = YES;
}

- (void)processLongConn {
    close(sock);
    _isStop = YES;
    _isSucc = NO;
}

- (int)connect:(struct sockaddr_in *)addr {
    sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sock == -1) {
        return errno;
    }
    int on = 1;
    setsockopt(sock, SOL_SOCKET, SO_NOSIGPIPE, &on, sizeof(on));
    setsockopt(sock, IPPROTO_TCP, TCP_NODELAY, (char *)&on, sizeof(on));
    
    struct timeval timeout;
    timeout.tv_sec = 10;
    timeout.tv_usec = 0;
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout, sizeof(timeout));
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(timeout));
    
    sigset(SIGALRM, tcp_conn_handler);
    alarm(1);
    int conn_res = connect(sock, (struct sockaddr *)addr, sizeof(struct sockaddr));
    alarm(0);
    sigrelse(SIGALRM);
    
    if (conn_res < 0) {
        int err = errno;
        close(sock);
        return err;
    }
    close(sock);
    return 0;
}

- (NSString *)convertDomainToIp:(NSString *)host {
    const char *hostaddr = [host UTF8String];
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(_port);
    if (hostaddr == NULL) {
        hostaddr = "\0";
    }
    addr.sin_addr.s_addr = inet_addr(hostaddr);
    
    if (addr.sin_addr.s_addr == INADDR_NONE) {
        struct hostent *remoteHost = gethostbyname(hostaddr);
        if (remoteHost == NULL || remoteHost->h_addr == NULL) {
            _pingDetails.error = [NSString stringWithFormat:@"Host %@ not found", host];
            _complete(_pingDetails);
            return NULL;
        }
        addr.sin_addr = *(struct in_addr *)remoteHost->h_addr;
        return [NSString stringWithFormat:@"%s",inet_ntoa(addr.sin_addr)];
    }
    _pingDetails.ip = host;
    return host;
}

@end
