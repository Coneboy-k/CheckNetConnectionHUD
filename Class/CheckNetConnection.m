//
//  KKCheckNetConnection.m
//  HBSB
//
//  Created by SunKe on 13-12-16.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.
//

#import "CheckNetConnection.h"

#import "Reachability.h"
#import "KKHUD.h"

static CheckNetConnection *kkCheckNetConnection = nil;

@implementation CheckNetConnection


/**
 *  初始化网络检测单例
 *
 *  @return 网络检测单例对象
 */
+ (id)sharedCheckNetConnection{
    
    static dispatch_once_t netCheck;
    dispatch_once(&netCheck,^{
        if (kkCheckNetConnection ==nil) {
            kkCheckNetConnection = [[[self class] alloc] init];
        }
    });
    
    return kkCheckNetConnection;
}

+ (id) allocWithZone:(NSZone *)zone{
    
    @synchronized (self) {
        if (kkCheckNetConnection == nil) {
            kkCheckNetConnection = [super allocWithZone:zone];
            return kkCheckNetConnection;
        }
    }
    
    return nil;
}

+ (id) copyWithZone:(NSZone *)zone{
    
    return self;
}

/**
 *  通过通过Reachability进行检测，检测方式以回调方式显示
 */
- (void)netCheck{
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability * reachability){
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"Block Says Reachable");
            switch ([reachability currentReachabilityStatus]) {
                case 1:
//                    NSLog(@"ReachableViaWWLAN");
                    [KKHUD show:@" 切换到 2G/3G"];
                    break;
                case 2:
//                    NSLog(@"ReachableViaWiFi");
                    [KKHUD show:@" 切换到  WiFi"];
                    break;
                    
                default:
                    break;
            }
        });
    };
    
    // 防止循环调用
    __weak CheckNetConnection *weakNetCheck = self;
    
    reach.unreachableBlock = ^(Reachability * reachability){
        dispatch_async(dispatch_get_main_queue(), ^{
            // CMCC对网络的延迟判断有延迟不准确！所以通过延迟判断网络准确状态。
            [weakNetCheck isRealNotInline];
        });
    };
    
    [reach startNotifier];
}


- (void) isRealNotInline{
    
    __weak CheckNetConnection *weakNetCheck = self;
    
     // GCD 外层。用来做延迟检测
    double delayInSeconds = 5.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NSLog(@"-- current status: %@", reach.currentReachabilityString);
        // 提高效率来判断现在是哪个函数。
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger typeTmp = [weakNetCheck getNetworkType];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (typeTmp == 0) {
                    //                    NSLog(@"真的没网络了");
                    [KKHUD show:@"暂时无法访问网络"];
                }
            });
        });
	});
 
}



// 通过statusBar判断网络状态
-(NSInteger )getNetworkType
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSInteger netType;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:{
            netType = 0; //NSLog(@"No wifi or cellular");
        }
            break;
        case 1:{
            netType = 1;//            NSLog(@"2G");
        } break;
        case 2:{
            netType = 2;//            NSLog(@"3G");
        }
            break;
        case 3:{
            netType = 3;//            NSLog(@"4G");
        }
            break;
        case 4:{
            netType = 4;//            NSLog(@"LTE");
        }
            break;
        case 5:{
            netType = 5;//            NSLog(@"Wifi");
        }
            break;
        default:{
            netType = 6;
        }break;
    }
    
    return netType ;
}




@end
