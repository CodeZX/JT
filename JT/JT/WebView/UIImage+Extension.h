//
//  UIImage+Extension.h
//  
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 获取没有被渲染的图片
 
 @param imageName 图片名称
 @return 没有渲染的图片
 */
+ (UIImage *)renderOriginalImageWithImageName:(NSString *)imageName;
+ (UIImage *)resizableImage:(NSString *)name;
/* 裁剪圆形图片 */
+ (UIImage *)clipImage:(UIImage *)image;

// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
