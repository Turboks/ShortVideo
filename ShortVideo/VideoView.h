//
//  VideoView.h
//  ShortVideo
//
//  Created by Turboks on 2021/2/6.
//

#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoView : UIView
@property (nonatomic, strong) AVPlayer      * avplayer;   //播放器
@property (nonatomic, strong) UIImageView   * playOrStop; //开始暂停
@property (nonatomic) bool isPlay;
-(instancetype)setURL:(NSURL *)url andController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
