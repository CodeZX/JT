//
//  CountdownView.m
//  GuideView
//
//  Created by 天蓝 on 2016/12/2.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "CountdownView.h"

@implementation CountdownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor colorWithRed:0.02f green:0.69f blue:1.00f alpha:1.00f].CGColor;
        shapeLayer.lineWidth = 1.0;
        [self.layer addSublayer:shapeLayer];
        
        CGFloat w = CGRectGetWidth(frame);
        CGFloat h = CGRectGetHeight(frame);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(w/2, h/2)
                                                            radius:MIN(w, h)/2
                                                        startAngle:-M_PI_2
                                                          endAngle:3 * M_PI_2
                                                         clockwise:YES];
        shapeLayer.path = path.CGPath;
        
        // 倒计时的时间
        NSInteger time = 3;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        animation.duration = time;
        animation.fromValue = @(0.f);
        animation.toValue = @(1.f);
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeBoth;
        [shapeLayer addAnimation:animation forKey:nil];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.text = @"跳过";
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.00f];
        [self addSubview:label];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"11111 %s", __func__);
            [self tapAction];
        });
    }
    return self;
}

- (void)tapAction
{
    if (self.blockTapAction) {
        self.blockTapAction();
    }
}

@end
