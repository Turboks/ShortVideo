//
//  ViewController.m
//  ShortVideo
//
//  Created by Turboks on 2021/2/6.
//

#define width   self.view.bounds.size.width
#define height  self.view.bounds.size.height

#define VideoV self.playerList[page]

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import "VideoView.h"


@interface ViewController ()<UIScrollViewDelegate>
{
    int page;
}
@property (nonatomic, strong) UIScrollView * scrollview;
@property (nonatomic, strong) NSMutableArray * videoList;
@property (nonatomic, strong) NSMutableArray<VideoView *> * playerList;
@property (nonatomic, strong) VideoView * videoV;
@end

@implementation ViewController
- (NSMutableArray *)videoList{
    if (_videoList == nil) {
        _videoList = [[NSMutableArray alloc] initWithObjects:@"v6",@"v1",@"v3",@"v4",@"v5",@"v2",nil];
    }
    return _videoList;
}
- (NSMutableArray<VideoView *> *)playerList{
    if (_playerList == nil) {
        _playerList = [[NSMutableArray alloc] init];
    }
    return _playerList;
}
- (UIScrollView *)scrollview{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _scrollview.contentSize = CGSizeMake(width, height * self.videoList.count);
        _scrollview.bounces = NO;
        _scrollview.pagingEnabled = YES;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.automaticallyAdjustsScrollIndicatorInsets = NO;
        _scrollview.delegate = self;
    }
    return _scrollview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page = 0;
    [self.view addSubview:self.scrollview];
    [self addVideo];
}
-(void)addVideo{
    for (int i = 0; i < self.videoList.count; i++) {
        self.videoV = [[VideoView alloc] initWithFrame:CGRectMake(0, i * height, width, height)];
        //本地视频
        NSString * str = [NSString stringWithFormat:@"%@",self.videoList[i]];
        NSString * localPath = [[NSBundle mainBundle] pathForResource:str ofType:@"mov"];
        NSURL * localUrl = [NSURL fileURLWithPath:localPath];
        [self.videoV setURL:localUrl andController:self];
        [self.playerList addObject:self.videoV];
        [self.scrollview addSubview:self.videoV];
        self.videoV.isPlay = NO;
    }
    [self.playerList[0].avplayer play];
    self.playerList[0].isPlay = YES;
}
//滑动停止、获取当前处于第几页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self videoPause];
    page = scrollView.contentOffset.y / height;
    [self videoPlay];
}

-(void)videoPause{
    [VideoV.avplayer pause];
    VideoV.isPlay = NO;
}

-(void)videoPlay{
    [VideoV.avplayer play];
    VideoV.isPlay = YES;
    VideoV.playOrStop.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
