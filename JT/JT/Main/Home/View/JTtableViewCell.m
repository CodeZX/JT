//
//  JTtableViewCell.m
//  JT
//
//  Created by 周鑫 on 2018/6/22.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "JTtableViewCell.h"
#import "MusicModel.h"

@interface JTtableViewCell  ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation JTtableViewCell
+ (JTtableViewCell *)tableViewCellWith:(UITableView *)tableView Identifier:(NSString *)identifier {
    JTtableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JTtableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)setMusicModel:(MusicModel *)musicModel {
    _musicModel = musicModel;
    self.iconImageView.image = [UIImage imageNamed:musicModel.imageName];
    self.titleLabel.text = musicModel.title;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
