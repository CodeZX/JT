//
//  musicModel.h
//  JT
//
//  Created by 周鑫 on 2018/6/22.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *musicPath;
- (instancetype)initWithTitle:(NSString *)title ImageName:(NSString *)imageName MusicPath:(NSString *)musicPaht;
@end
