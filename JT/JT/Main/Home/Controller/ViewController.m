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
#import "SDSilderView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,SDSilderViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSMutableArray *audioPlayArray;
@property (nonatomic,strong) SDSilderView *silderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
@property (nonatomic,copy)    NSString *currentCity;//城市
@property (nonatomic,copy)    NSString *strLatitude;//经度
@property (nonatomic,copy)    NSString *strLongitude;//维度


@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *temphighLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic,assign) BOOL    playing;

@end

@implementation ViewController
{
    
    int playIndext;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    playIndext = 0;
    
    for (MusicModel *musicModel in self.dataSource) {
        
      AVAudioPlayer *audioPlayer =   [self createPlayerWithMusicModel:musicModel];
      if (audioPlayer) {
          [self.audioPlayArray addObject:audioPlayer];
//          [audioPlayer play];
       }
    }
    
    
    // 注册中断事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    // 注册保护用户隐私的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    [self setupUI];
    [self locatemap];
}

- (void)setupUI {
    
    CGFloat X  = self.view.center.x - 150;
    CGFloat Y = self.view.center.y + 50;
    SDSilderView *silderView = [SDSilderView initWithPosition:CGPointMake(X, Y) viewRadius:80];
     silderView.value = 20;
    silderView.delegate = self;
    [self.view addSubview: silderView];
    
   
    
}

- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]canOpenURL:settingURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    self.strLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.strLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    //当前的经纬度
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 1.0){//如果调用已经一次，不再执行
        return;
    }
    [self requestWeather];
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            if (!self.currentCity) {
                self.currentCity = @"无法定位当前城市";
            }
            //看需求定义一个全局变量来接收赋值
            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
            NSLog(@"当前城市 - %@",self.currentCity);//当前城市
            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
//            NSString *message = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placeMark.country,self.currentCity,placeMark.subLocality,placeMark.thoroughfare,placeMark.name];
//
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
//            [alert show];
        }else if (error == nil && placemarks.count){
            
            NSLog(@"NO location and error return");
        }else if (error){
            
            NSLog(@"loction error:%@",error);
        }
    }];
}



- (void)handleRouteChange:(NSNotification *)notification {
    
    
    NSDictionary *info = notification.userInfo;
    NSLog(@"info--%@",info);
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        AVAudioSessionRouteDescription *description = info[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = description.outputs[0];
        NSString *portType = portDescription.portType;
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]){
            [self stop];
        }
    }
    
}

- (void)handleInterruption:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) {// 开始中断
        
        [self stop];
        
    }else {// 中断结束
        
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            [self play];
        }
        
    }
}



- (AVAudioPlayer*)createPlayerWithMusicModel:(MusicModel*)musicModel {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL*fileURL = [bundle URLForResource:musicModel.musicPath withExtension:@"mp3"];
    
    NSError *error;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&error];
    if(audioPlayer) {
        audioPlayer.numberOfLoops= -1;//无限循环播放
        audioPlayer.enableRate=YES;//设置为YES可以控制播放速率
        audioPlayer.volume = .2;
        [audioPlayer prepareToPlay];
        return audioPlayer;
    }else{
        NSLog(@"创建播放器出错error: %@",error.localizedDescription);
        return  nil;
        
    }
    
}


- (void)play {
    
    if(!self.playing) {
        
        NSTimeInterval delayTime = [self.audioPlayArray[0] deviceCurrentTime]+0.01;
        
        for(AVAudioPlayer *player in self.audioPlayArray){
            
            [player playAtTime:delayTime];
            
        }
        self.playing=YES;
    }
    
}

- (void)stop {
    
    if (self.playing) {
        for (AVAudioPlayer *player in self.audioPlayArray) {
            [player stop];
            player.currentTime = 0.0f;
        }
        self.playing = NO;
    }
    
}


- (IBAction)play:(UIButton *)sender {
    
    if(!self.playing) {
        
        [self play];
        sender.selected = YES;
        
    }else {
        
        [self stop];
        sender.selected = NO;
    }
}


// 音量
- (void)adjustVolume:(CGFloat)volume forPlayerAtIndex:(NSInteger)index {
    if([self isValidIndex:index]){
        AVAudioPlayer *player = self.audioPlayArray[index];
        player.volume = volume;
    }
}

// 防止数组越界
- (BOOL)isValidIndex:(NSUInteger)index {
    
    return index == 0 || index < self.audioPlayArray.count;
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
//    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    v.backgroundColor  = [UIColor colorWithRed:200 green:200 blue:200 alpha:1];
//    [cell setSelectedBackgroundView:v];
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    playIndext =(int) indexPath.row;
    
    CGFloat X  = self.view.center.x - 150;
    CGFloat Y = self.view.center.y + 50;
    SDSilderView *silderView = [SDSilderView initWithPosition:CGPointMake(X, Y) viewRadius:80];
    silderView.value = 20;
    silderView.delegate = self;
    [self.view addSubview: silderView];
    [self.view willRemoveSubview:self.silderView];
    self.silderView = silderView;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark ----代理 ---

-(void)silderViewNewChangeValue:(float)newChangeValue{
    
    
//    _myLabel.text = [NSString stringWithFormat:@"%.2f",newChangeValue];
    [self adjustVolume:newChangeValue forPlayerAtIndex:playIndext];
    
    
}

#pragma mark --------------------------lazy load  ----------------------------------------
- (NSMutableArray *)audioPlayArray {
    if (!_audioPlayArray) {
        _audioPlayArray = [[NSMutableArray alloc]init];
    
    }
    return _audioPlayArray;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[ [[MusicModel alloc]initWithTitle:@"星火燎原" ImageName:@"icon_星火燎原" MusicPath:@"DryLawn Fire"],
                         [[MusicModel alloc]initWithTitle:@"丝丝蝉鸣" ImageName:@"icon_丝丝蝉鸣" MusicPath:@"Dusk Cicadas"],
                         [[MusicModel alloc]initWithTitle:@"拍岸潮汐" ImageName:@"icon_拍岸潮汐" MusicPath:@"Low Tide"],
                         [[MusicModel alloc]initWithTitle:@"流水潺潺" ImageName:@"icon_流水潺潺" MusicPath:@"Babbling Brook"],
                         [[MusicModel alloc]initWithTitle:@"黑白琴键" ImageName:@"icon_黑白琴键" MusicPath:@"Slient Piano"],
                         [[MusicModel alloc]initWithTitle:@"铁轨声" ImageName:@"icon_铁轨声" MusicPath:@"Inside Train"],
                         [[MusicModel alloc]initWithTitle:@"山间水滴" ImageName:@"icon_山间水滴" MusicPath:@"Valley Drip"], 
                         [[MusicModel alloc]initWithTitle:@"悠悠长笛" ImageName:@"icon_悠悠长笛" MusicPath:@"Leisure Flute"],
                         [[MusicModel alloc]initWithTitle:@"檐落春雨" ImageName:@"icon_檐落春雨" MusicPath:@""],
                         [[MusicModel alloc]initWithTitle:@"林间清晨" ImageName:@"icon_林间清晨" MusicPath:@"Park Bird"],
                         [[MusicModel alloc]initWithTitle:@"雷声大作" ImageName:@"icon_雷声大作" MusicPath:@"Thundering"],
                         [[MusicModel alloc]initWithTitle:@"南风起" ImageName:@"icon_南风起" MusicPath:@"South Wind"],
                         [[MusicModel alloc]initWithTitle:@"落耳铃" ImageName:@"icon_落耳铃" MusicPath:@"Echo Chimes"],
                         [[MusicModel alloc]initWithTitle:@"清脆风铃" ImageName:@"icon_清脆风铃" MusicPath:@"Clear Chimes"],
                         [[MusicModel alloc]initWithTitle:@"乡村夜色" ImageName:@"icon_乡村夜色" MusicPath:@"Village Night"],
                         
                        
                        
                        ];
    }
    return _dataSource;
}



/***********   **********/

- (void)requestWeather
{
    double lat = [self.strLatitude doubleValue];
    double lng = [self.strLongitude doubleValue];
//    double lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lat"];
//    double lng = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lng"];
    
    NSString *appcode = @"ca9814a36f8443d48a4095eb8016fee1";
    NSString *host = @"http://jisutqybmf.market.alicloudapi.com";
    NSString *path = @"/weather/query";
    NSString *method = @"GET";
    NSString *querys =  [NSString stringWithFormat:@"?location=%f,%f", lat,lng];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    // *bodys = @"";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       //                                                       NSLog(@"Response object: %@" , response);
                                                       //                                                       NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                                                       //
                                                       //                                                       //打印应答中的body
                                                       //                                                       NSLog(@"Response body: %@" , bodyString);
                                                       
                                                       if (body == nil) {
                                                           return ;
                                                       }
                                                       NSDictionary* bodyDic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:nil];
                                                       //NSLog(@"%@", bodyDic);
                                                       
                                                       id result = bodyDic[@"result"];
                                                       
                                                       if (![result isKindOfClass:[NSDictionary class]] || result == nil) {
                                                           return;
                                                       }
                                                       
                                                       NSString* city = result[@"city"];
                                                       NSString* week = result[@"week"];
                                                       NSString* weather = result[@"weather"];
                                                       NSString* templow = result[@"templow"];
                                                       NSString* temphigh = result[@"temphigh"];
                                                       NSString* winddirect = result[@"winddirect"];
                                                       NSString *img = result[@"img"];
                                                       NSString *date = result[@"date"];
                                                       //weather = @"暴雨";
                                                       NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@",city,week,weather,templow,temphigh,winddirect,img,date);
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           
                                                           self.temphighLabel.text = [NSString stringWithFormat:@"%@℃",temphigh];
                                                           self.weatherLabel.text = weather;
                                                           self.dateLabel.text = date;
                                                           if ([img isEqualToString:@"0"]) {
                                                               self.weatherImageView.image = [UIImage imageNamed:@"晴天"];
                                                           }else if([img isEqualToString:@"1"]) {
                                                               self.weatherImageView.image = [UIImage imageNamed:@"多云"];
                                                           }else if([img isEqualToString:@"2"]) {
                                                               self.weatherImageView.image = [UIImage imageNamed:@"阴天"];
                                                           }else if([img isEqualToString:@"9"]) {
                                                               self.weatherImageView.image = [UIImage imageNamed:@"大雨"];
                                                           }else if([img isEqualToString:@"3"]) {
                                                                self.weatherImageView.image = [UIImage imageNamed:@"阵雨"];
                                                           } else if([img isEqualToString:@"7"]) {
                                                                self.weatherImageView.image = [UIImage imageNamed:@"小雨"];
                                                           }
//                                                           self.leftLabel.text = city;
//                                                           self.rightLabel1.text = [NSString stringWithFormat:@"%@ %@ %@\n\n",week,weather,winddirect];
//                                                           self.rightLabel2.text = [NSString stringWithFormat:@"%@°C - %@°C", templow, temphigh];
//                                                           
//                                                           if ([weather containsString:@"雨"] || [winddirect containsString:@"雨"]) {
//                                                               self.flyImageView.image = [UIImage imageNamed:@"不宜飞行"];
//                                                               CGRect frame = self.flyImageView.frame;
//                                                               CGPoint center = self.flyImageView.center;
//                                                               frame.size.width = 119;
//                                                               self.flyImageView.frame = frame;
//                                                               self.flyImageView.center = center;
//                                                           }else{
//                                                               self.flyImageView.image = [UIImage imageNamed:@"宜飞行"];
//                                                               CGRect frame = self.flyImageView.frame;
//                                                               CGPoint center = self.flyImageView.center;
//                                                               frame.size.width = 88;
//                                                               self.flyImageView.frame = frame;
//                                                               self.flyImageView.center = center;
//                                                           }
                                                       });
                                                   }];
    
    [task resume];
}

@end
