//
//  BBGestureBaseController.m
//  BBGestureBack
//
//  Created by user on 2018/3/17.
//  Copyright © 2018年 Bonway. All rights reserved.
//

#import "BBGestureBaseController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
static char szListenTabbarViewMove[] = "listenTabViewMove";

@interface BBGestureBaseController ()

@end

@implementation BBGestureBaseController

- (id)init{
    self = [super init];
    if (self) {
        self.gestureEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end



@implementation ScreenShotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrayImage = [NSMutableArray array];
        self.backgroundColor = [UIColor blackColor];
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
        [self addSubview:_imgView];
        [self addSubview:_maskView];
        
        [[AppDelegate shareAppDelegate].window.rootViewController.view addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:szListenTabbarViewMove];
        
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == szListenTabbarViewMove)
    {
        NSValue *value  = [change objectForKey:NSKeyValueChangeNewKey];
        CGAffineTransform newTransform = [value CGAffineTransformValue];
        [self showEffectChange:CGPointMake(newTransform.tx, 0) ];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}



- (void)showEffectChange:(CGPoint)pt
{
    if (pt.x > 0)
    {
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-pt.x / ([UIScreen mainScreen].bounds.size.width) * 0.4 + 0.4];
        _imgView.transform = CGAffineTransformMakeScale(0.95 + (pt.x / ([UIScreen mainScreen].bounds.size.width) * 0.05), 0.95 + (pt.x / ([UIScreen mainScreen].bounds.size.width) * 0.05));
    }
}

- (void)restore
{
    if (_maskView && _imgView)
    {
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
        _imgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
}

- (void)screenShot
{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), YES, 0);
    [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    self.imgView.image = sendImage;
    self.imgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
}

- (void)dealloc
{
    [[AppDelegate shareAppDelegate].window.rootViewController.view removeObserver:self forKeyPath:@"transform" context:szListenTabbarViewMove];
    
}
@end
