//
//  musicModel.m
//  JT
//
//  Created by 周鑫 on 2018/6/22.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
- (instancetype)initWithTitle:(NSString *)title ImageName:(NSString *)imageName MusicPath:(NSString *)musicPaht {
    self = [super init];
    if (self) {
        self.title = title;
        self.imageName = imageName;
        self.musicPath = musicPaht;
    }
    return self;
}
@end
