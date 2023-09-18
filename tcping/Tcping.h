//
//  Tcping.h
//  tcping
//
//  Created by ParadiseDuo on 2020/5/11.
//  Copyright © 2020 MacClient. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tcping : NSObject
@property (nonatomic, strong) NSDate * startTime;
@property (nonatomic) NSTimeInterval speed;
@property (nonatomic, copy) NSString * domain;
@property (nonatomic, copy) NSString * host;
@property (nonatomic) UInt16 port;
@property (nonatomic) dispatch_group_t group;
@property (nonatomic) dispatch_queue_t queue;

- (instancetype)initWith:(dispatch_group_t)group queue:(dispatch_queue_t) queue;

- (void)connectSocket:(NSString *)domain port:(UInt16)port timeout:(NSTimeInterval)timeout;

@end

NS_ASSUME_NONNULL_END
