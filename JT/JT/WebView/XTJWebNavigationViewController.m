//
//  XTJWebNavigationViewController.m
//  FiftyOneCraftsman
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import "XTJWebNavigationViewController.h"
#import "ATJWebViewController.h"
#import "UIImage+Extension.h"

//RGB 颜色
#define KRGBA(r,g,b,a)  [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define RGB(r,g,b) KRGBA(r,g,b,1.0f)

@interface XTJWebNavigationViewController ()

@end

@implementation XTJWebNavigationViewController

+ (void)initialize {
    
    if (self == [XTJWebNavigationViewController class]) {
        // 1. 获取导航条标识
        UINavigationBar * navbar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XTJWebNavigationViewController class]]];
        
        //获取导航条颜色
        UIColor * navColor = RGB(0, 140, 240);
        //把颜色生成图片
        UIImage * alphaImg = [UIImage imageWithColor:navColor];
        [navbar setBackgroundImage:alphaImg forBarMetrics:UIBarMetricsDefault];
        // 设置字体颜色大小
        NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
        // 字体大小
        dictM[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
        // 字体颜色
        dictM[NSForegroundColorAttributeName] = [UIColor blackColor];
        
        navbar.titleTextAttributes = dictM;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ATJWebViewController *webVC = [[ATJWebViewController alloc] init];
        [webVC loadWebURLSring:self.url];
    
    [self pushViewController:webVC animated:YES];

}

@end
