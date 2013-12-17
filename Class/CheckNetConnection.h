//
//  KKCheckNetConnection.h
//  HBSB
//
//  Created by SunKe on 13-12-16.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CheckNetConnection : NSObject


/**
 *  初始化检测网络状态单例
 *
 *  @return 单例对象
 */
+ (id) sharedCheckNetConnection;
+ (id) allocWithZone:(NSZone *)zone;
+ (id) copyWithZone:(NSZone *)zone;

/**
 *  通过通过Reachability进行检测，检测方式以回调方式显示
 */
- (void)netCheck;

@end
