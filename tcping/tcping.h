//
//  tcping.h
//  tcping
//
//  Created by Youssef on 2020/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TcpingDetail : NSObject
@property (nonatomic, copy) NSString * ip;
@property (nonatomic, copy) NSString * domain;
@property (nonatomic) NSUInteger port;
@property (nonatomic, copy) NSNumber * speed;
@property (nonatomic, copy) NSString * error;

@property (nonatomic) NSUInteger loss;
@property (nonatomic) NSUInteger count;
@property (nonatomic, copy) NSNumber * max_time;
@property (nonatomic, copy) NSNumber * avg_time;
@property (nonatomic, copy) NSNumber * min_time;
@end

typedef void (^TcpingHandler)(TcpingDetail *);

@interface tcping : NSObject
+ (void)start:(NSString * _Nonnull)host port:(NSUInteger)port count:(NSUInteger)count stepInfo:(TcpingHandler _Nonnull)step complete:(TcpingHandler _Nonnull)complete;

- (BOOL)isTcpPing;

- (void)stopTcpPing;

- (void)processLongConn;
@end

NS_ASSUME_NONNULL_END
