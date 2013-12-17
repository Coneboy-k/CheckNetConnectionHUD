//
//  KKHUD.m
//  HBSB
//
//  Created by SunKe on 13-12-16.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.
//

#import "KKHUD.h"

static NSString *reachabilityText = @"连接";

@interface KKHUD ()

@property (nonatomic, strong, readonly) UIButton *overlayView;
@property (nonatomic, strong, readonly) UIView *hudView;
@property (nonatomic, strong, readonly) UILabel *reachabilityLable;

- (UIColor *)hudBackgroundColor;

@end

@implementation KKHUD

@synthesize hudBackgroundColor = _uiHudBgColor;

@synthesize overlayView, hudView, reachabilityLable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark - 使用单例控制HUD的唯一性

+ (KKHUD *)sharedHUD{
    static dispatch_once_t once;
    static KKHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}


#pragma mark - 控制HUD显示或者隐藏

+ (void)show:(NSString *)reachabilityString{
    
    reachabilityText = reachabilityString;
    [[self sharedHUD] showReachability];
    
}

+ (void)dismiss{
    
	[[self sharedHUD] dismissReachability];
    
}

+ (void)dismissHUDTimer{
    
    // 通过GCD做一个定时器  2.0S后取消显示
    double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[self sharedHUD] dismissReachability];
	});
    
}


#pragma mark - 展示、隐藏具体实现

- (void)showReachability{
    
    //如果承载的画布的爸爸页面不存在
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
    }
    
    if(!self.superview){
        [self.overlayView addSubview:self];
    }
    
    
    // 加载的动画。
    [self.hudView setAlpha:0.3f];
    [UIView animateWithDuration:0.5
	                 animations:^{
                         [self.hudView setAlpha:1.0f];
                         [self.hudView setFrame:CGRectMake(self.hudView.frame.origin.x-100,
                                                           self.hudView.frame.origin.y,
                                                           self.hudView.frame.size.width,
                                                           self.hudView.frame.size.height)];
	                 }
	                 completion:^(BOOL finished) {
                         // 2.0S后取消显示
                         [KKHUD dismissHUDTimer];
                     }];
    
}

- (void)dismissReachability{
    
    [UIView animateWithDuration:0.5
	                 animations:^{
                         [self.hudView setAlpha:0.6f];
                         [self.hudView setFrame:CGRectMake(self.hudView.frame.origin.x+110,
                                                           self.hudView.frame.origin.y,
                                                           self.hudView.frame.size.width,
                                                           self.hudView.frame.size.height)];
                     }
	                 completion:^(BOOL finished) {
                         [reachabilityLable removeFromSuperview];
                         reachabilityLable = nil;
                         
                         [hudView removeFromSuperview];
                         hudView = nil;
                         
                         [overlayView removeFromSuperview];
                         overlayView = nil;

                     }];
    
}


#pragma mark - 初始化HUD所需所有页面

// 大的画布
- (UIButton *)overlayView {
    
    if(!overlayView) {
//        overlayView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayView = [[UIButton alloc] initWithFrame:CGRectMake(320, 126, 110, 110)];

        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor clearColor];
        [overlayView setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [overlayView setBackgroundImage:[UIImage new] forState:UIControlStateDisabled];
    }
    
    return overlayView;
}

// 小的画布
- (UIView *)hudView {
    
    if(!hudView) {
        hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        hudView.layer.cornerRadius = 10;
        hudView.layer.masksToBounds = YES;
        
        // UIAppearance is used when iOS >= 5.0
		hudView.backgroundColor = self.hudBackgroundColor;
        
        hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:hudView];
        [hudView addSubview:self.reachabilityLable];
        [self.reachabilityLable setText:reachabilityText];

    }
    
    return hudView;
}

// 上面的文字
- (UILabel *)reachabilityLable{
    
    if (!reachabilityLable) {
        reachabilityLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 90, 100)];
        reachabilityLable.backgroundColor = [UIColor clearColor];
        reachabilityLable.textColor = [UIColor whiteColor];
        reachabilityLable.font = [UIFont boldSystemFontOfSize:20];
        reachabilityLable.textAlignment = NSTextAlignmentCenter;
        [reachabilityLable setNumberOfLines:0];

        [self.hudView addSubview:reachabilityLable];
    }
    
    return reachabilityLable;
}


#pragma mark - 设置颜色

- (UIColor *)hudBackgroundColor {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
    if(_uiHudBgColor == nil) {
        _uiHudBgColor = [[[self class] appearance] hudBackgroundColor];
    }
    
    if(_uiHudBgColor != nil) {
        return _uiHudBgColor;
    }
#endif
    
    return [UIColor colorWithWhite:0 alpha:0.8];
}


@end
