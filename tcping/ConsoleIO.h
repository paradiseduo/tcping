//
//  ConsoleIO.h
//  tcping
//
//  Created by ParadiseDuo on 2020/5/11.
//  Copyright © 2020 MacClient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tcping.h"

enum OutputType: NSInteger {
    OutputTypeError,
    OutputTypeStandard
};

NS_ASSUME_NONNULL_BEGIN

@interface ConsoleIO : NSObject
+ (void)writeMessage:(NSString *)message to:(NSInteger) to;
+ (void)printUsage;
+ (void)printReulst:(BOOL)isFinish detail:(Tcping *)detail count:(NSUInteger)count lossCount:(NSUInteger)lossCount min:(NSNumber *)min max:(NSNumber *)max avge:(NSNumber *)avge;
@end

NS_ASSUME_NONNULL_END
