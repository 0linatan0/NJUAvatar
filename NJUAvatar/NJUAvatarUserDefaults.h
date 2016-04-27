//
//  NJUAvatarUserDefaults.h
//  NJUAvatar
//
//  Created by tanli on 16/4/27.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NJUAvatarUserDefaults : NSObject

+ (void)saveAvatar:(UIImage *)image;

+ (UIImage *)avatar;

+ (void)saveBadge:(UIImage *)image;

+ (UIImage *)badge;


@end
