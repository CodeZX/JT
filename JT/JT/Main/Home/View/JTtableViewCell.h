//
//  JTtableViewCell.h
//  JT
//
//  Created by 周鑫 on 2018/6/22.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class   MusicModel;
@interface JTtableViewCell : UITableViewCell
@property (nonatomic,strong) MusicModel *musicModel;
+ (JTtableViewCell *)tableViewCellWith:(UITableView *)tableView Identifier:(NSString *)identifier;
@end
