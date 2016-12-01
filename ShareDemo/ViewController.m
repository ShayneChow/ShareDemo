//
//  ViewController.m
//  ShareDemo
//
//  Created by Xiang on 2016/11/30.
//  Copyright © 2016年 Weplus Technology Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

#define ZXScreenW [UIScreen mainScreen].bounds.size.width
#define ZXScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (strong, nonatomic) UIImage *viewImage;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) UIView *mask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIGraphicsBeginImageContext(self.view.bounds.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    _viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
}

// 保存到本地相册
- (IBAction)saveImage:(id)sender {
    // 生成图片
    UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 30));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    _viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 保存
     UIImageWriteToSavedPhotosAlbum(_viewImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

// 分享图片到微信
- (IBAction)shareImageToWechat:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    //显示分享面板
//    [UMSocialUIManager showShareMenuViewInView:nil sharePlatformSelectionBlock:^(UMSocialShareSelectionView *shareSelectionView, NSIndexPath *indexPath, UMSocialPlatformType platformType) {
//        // 根据platformType调用相关平台进行分享
//        
//    }];
    
    // 生成图片
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    _viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成水印
    UIImage * maskImage = [self image:[UIImage imageNamed:@"expressions_003"] WithStringWaterMark:@"这是个牛逼的水印！" inRect:CGRectMake(100, 40, 300, 100) color:[UIColor redColor] font:[UIFont boldSystemFontOfSize:20]];
    // 加水印
    UIImage * image = [self addImage:_viewImage addMsakImage:maskImage msakRect:CGRectMake(0, 0, 400, 100)];
    // 保存
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
//    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Middle;
//    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        //[self runShareWithType:platformType];
//        [weakSelf shareImageToPlatformType:UMSocialPlatformType_WechatSession withImage:image];
//    }];
    [self showMaskViewWithImage:image];
}

- (void)showMaskViewWithImage:(UIImage *)image {
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXScreenW, ZXScreenH)];
     mask.backgroundColor = [UIColor clearColor];
     //mask.alpha = 0.45;
     [self.view.window addSubview:mask];
     
     UIView *cover = [[UIView alloc] init];
     [mask addSubview:cover];
     cover.frame = mask.frame;
     cover.backgroundColor = [UIColor blackColor];
     cover.alpha = 0.5;
     
     UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZXScreenH - 80, ZXScreenH - 160)];
     tipImageView.image = image;
    _shareImage = image;
    tipImageView.contentMode = UIViewContentModeScaleAspectFit;
     [mask addSubview:tipImageView];
    tipImageView.center = mask.center;
    
    UIButton * shareBtn = [[UIButton alloc] init];
    [mask addSubview:shareBtn];
    shareBtn.frame = CGRectMake(40, 80 - 30, 100, 30);
    [shareBtn setTitle:@"分享到微信" forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor greenColor]];
    [shareBtn addTarget:self action:@selector(shareImageToPlatformType:) forControlEvents:UIControlEventTouchUpInside];
     
    _mask = mask;
}

- (void)touchMask {
    [_mask removeFromSuperview];
}

- (void)shareWithImage:(UIImage *)image {
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    } else {
        message = [error description];
    }
    
    ZXLog(@"message is %@", message);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/**
 加半透明水印
 @param useImage 需要加水印的图片
 @param maskImage 水印
 @returns 加好水印的图片
 */
- (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage msakRect:(CGRect)rect {
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    
    //四个参数为水印图片的位置
    [maskImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


- (UIImage *) image:(UIImage *)useImage WithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font {
    
    UIGraphicsBeginImageContext(CGSizeMake(400, 100));
    //原图
    [useImage drawInRect:CGRectMake(0, 0, 100, 100)];
    
    //文字颜色
    //[color set];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    attrs[NSForegroundColorAttributeName] = color;
    //水印文字
    [markString drawInRect:rect withAttributes:attrs];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *userinfo =result;
        NSString *message = [NSString stringWithFormat:@"name: %@\n icon: %@\n gender: %@\n",userinfo.name,userinfo.iconurl,userinfo.gender];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserInfo"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType withImage:(UIImage *)image {
    [_mask removeFromSuperview];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    
    //[shareObject setShareImage:[UIImage imageNamed:@"logo"]];
    [shareObject setShareImage:image];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType {
    [_mask removeFromSuperview];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    //shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    
    //[shareObject setShareImage:[UIImage imageNamed:@"logo"]];
    [shareObject setShareImage:_shareImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

@end
