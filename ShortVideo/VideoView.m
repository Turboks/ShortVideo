//
//  VideoView.m
//  ShortVideo
//
//  Created by Turboks on 2021/2/6.
//

#define width   self.bounds.size.width
#define height  self.bounds.size.height

#import "VideoView.h"

@interface VideoView()
{
    float  allTime;     //视频总长度
    double CurrentTime; //当前时间
}
@property (nonatomic, strong) UIViewController * controller;
@property (nonatomic, strong) UIImageView * logo;       //头像
@property (nonatomic, strong) UIImageView * like;       //喜欢
@property (nonatomic, strong) UIImageView * comment;    //评论
@property (nonatomic, strong) UIImageView * share;      //分享
@property (nonatomic, strong) UIProgressView * progress;//视频进度条
@end

@implementation VideoView
- (UIImageView *)logo{
    if (_logo == nil) {
        _logo = [[UIImageView alloc] initWithFrame:CGRectMake(width-70, height-440, 60, 60)];
        _logo.image = [UIImage imageNamed:@"logo"];
        _logo.layer.cornerRadius = 30;
        _logo.layer.masksToBounds = YES;
        _logo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logo;
}
- (UIImageView *)like{
    if (_like == nil) {
        _like = [[UIImageView alloc] initWithFrame:CGRectMake(width-60, height-350, 40, 40)];
        _like.image = [UIImage imageNamed:@"like"];
        _like.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _like;
}
- (UIImageView *)comment{
    if (_comment == nil) {
        _comment = [[UIImageView alloc] initWithFrame:CGRectMake(width-60, height-260, 40, 40)];
        _comment.image = [UIImage imageNamed:@"comment"];
        _comment.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _comment;
}
- (UIImageView *)share{
    if (_share == nil) {
        _share = [[UIImageView alloc] initWithFrame:CGRectMake(width-60, height-190, 40, 40)];
        _share.image = [UIImage imageNamed:@"share"];
        _share.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _share;
}
- (UIImageView *)playOrStop{
    if (_playOrStop == nil) {
        _playOrStop = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-50, height/2-50, 100, 100)];
        _playOrStop.image = [UIImage imageNamed:@"play"];
        _playOrStop.contentMode = UIViewContentModeScaleAspectFit;
        _playOrStop.hidden = YES;
    }
    return _playOrStop;
}
- (instancetype)setURL:(NSURL *)url andController:(nonnull UIViewController *)controller{
    
    self.controller = controller;
    AVPlayerItem * avplayerItem = [[AVPlayerItem alloc] initWithURL:url];
    self.avplayer = [[AVPlayer alloc] initWithPlayerItem:avplayerItem];
    AVPlayerLayer * playLayer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    playLayer.videoGravity = AVLayerVideoGravityResize;
    playLayer.frame = CGRectMake(0, 0, width, height);
    [self.layer addSublayer:playLayer];
    
    [self addSubview:self.logo];
    
    [self addSubview:self.like];
    
    [self addSubview:self.comment];
    
    [self addSubview:self.share];
    
    [self addSubview:self.playOrStop];
    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, height - 50, width, 10)];
    _progress.progressTintColor = [UIColor whiteColor];
    _progress.trackTintColor = [UIColor lightGrayColor];
    [_progress setProgress:0.0 animated:YES];
    [self addSubview:_progress];
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create(0, 0);
    [self.avplayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 20.0) queue:queue usingBlock:^(CMTime time) {
        //当前播放时间
        NSTimeInterval nowTime = CMTimeGetSeconds(time);
        //总时间
        NSTimeInterval totaltime = CMTimeGetSeconds(weakSelf.avplayer.currentItem.duration);
        float result = nowTime/totaltime;
        dispatch_async(dispatch_get_main_queue(), ^{
            //滑块进度
            [weakSelf.progress setProgress:result animated:YES];
            if (result == 1.0) {
                CMTime ttt = CMTimeMake(1, 1);
                [weakSelf.avplayer.currentItem seekToTime:ttt completionHandler:^(BOOL finished) {
                    [weakSelf.avplayer play];
                }];
            }
        });
    }];
    return self;
}

-(void)touchPlayOrStop{
    //播放中的视频
    if (_isPlay) {
        _isPlay = NO;
        [self.avplayer pause];
        self.playOrStop.hidden = NO;
    }else{
        _isPlay = YES;
        [self.avplayer play];
        self.playOrStop.hidden = YES;
    }
}
//单击
-(void)oneTapAction{
    [self touchPlayOrStop];
}
-(void)doubleTapAction:(CGPoint)point{
    __block int X = (int)point.x;
    int Y = (int)point.y;
    //设置图片显示之后消失
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    image.image = [UIImage imageNamed:@"aixin"];
    image.center = point;
    [self addSubview:image];
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        X += (arc4random() % 50)-50;
        image.frame = CGRectMake(X, Y-100, 80, 80);
        image.alpha = 0.5;
    } completion:^(BOOL finished) {
        [image removeFromSuperview];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    double nowTime = CACurrentMediaTime();
    double difference = nowTime - CurrentTime;
    if(difference > 0.25f) {
        [self performSelector:@selector(oneTapAction) withObject:nil afterDelay:0.25f];
    }else {
        //取消上一次的执行
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTapAction) object: nil];
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:touch.view];
        [self doubleTapAction:point];
    }
    CurrentTime =  nowTime;
}
@end
