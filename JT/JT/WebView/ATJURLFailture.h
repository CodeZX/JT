//
//  ATJURLFailture.h
//  FiftyOneCraftsman
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATJURLFailtureDelegate <NSObject>

-(void)didClickCleanBtn:(UIButton *)sender;

@end

@interface ATJURLFailture : UIView
@property (nonatomic, weak) id<ATJURLFailtureDelegate> delegate;

@end
