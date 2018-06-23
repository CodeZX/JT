//
//  ViewController.m
//  JT
//
//  Created by 周鑫 on 2018/6/22.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ViewController.h"
#import "JTtableViewCell.h"
#import "MusicModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"JTtableViewCell";
    JTtableViewCell *cell = [JTtableViewCell tableViewCellWith:tableView Identifier:identifier];
    cell.musicModel = self.dataSource[indexPath.row];
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[ [[MusicModel alloc]initWithTitle:@"星火燎原" ImageName:@"icon_星火燎原" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"丝丝蝉鸣" ImageName:@"icon_丝丝蝉鸣" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"拍岸潮汐" ImageName:@"icon_拍岸潮汐" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"流水潺潺" ImageName:@"icon_流水潺潺" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"黑白琴键" ImageName:@"icon_黑白琴键" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"铁轨声" ImageName:@"icon_铁轨声" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"山间水滴" ImageName:@"icon_山间水滴" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"悠悠长笛" ImageName:@"icon_悠悠长笛" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"檐落春雨" ImageName:@"icon_檐落春雨" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"林间清晨" ImageName:@"icon_林间清晨" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"雷声大作" ImageName:@"icon_雷声大作" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"南风起" ImageName:@"icon_南风起" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"落耳铃" ImageName:@"icon_落耳铃" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"清脆风铃" ImageName:@"icon_清脆风铃" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"乡村夜色" ImageName:@"icon_乡村夜色" MusicPath:@""],
                         
                        
                        
                        ];
    }
    return _dataSource;
}

@end
