//
//  CountdownView.h
//  GuideView
//
//  Created by 天蓝 on 2016/12/2.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView

@property (nonatomic, copy) void (^blockTapAction)(void);

@end
