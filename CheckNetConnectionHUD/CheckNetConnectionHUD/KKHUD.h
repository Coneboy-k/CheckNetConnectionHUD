//
//  KKHUD.h
//  HBSB
//
//  Created by SunKe on 13-12-16.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKHUD : UIView

+ (void)show:(NSString *)reachabilityString;
+ (void)dismiss;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
@property (readwrite, nonatomic, retain) UIColor *hudBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
#endif


@end
