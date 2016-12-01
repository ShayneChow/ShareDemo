//
//  ViewController.h
//  ShareDemo
//
//  Created by Xiang on 2016/11/30.
//  Copyright © 2016年 Weplus Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define ZXString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define ZXLog(...) printf("<<%s 第%d行>>: %s\n\n", [ZXString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define ZXLog(...)
#endif

@interface ViewController : UIViewController


@end

