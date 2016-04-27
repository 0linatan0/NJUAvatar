//
//  NJUAvatarUserDefaults.m
//  NJUAvatar
//
//  Created by tanli on 16/4/27.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import "NJUAvatarUserDefaults.h"

@implementation NJUAvatarUserDefaults

+ (void)saveAvatar:(UIImage *)image
{
    //存储照片
    NSData *imageData= [NSKeyedArchiver archivedDataWithRootObject:image];
    // save NSData-object to UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"avatar"];
}

+ (UIImage *)avatar
{
    UIImage *avatar;
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    if(imageData != nil)
    {
        avatar = [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
    }
    return avatar;
}


+ (void)saveBadge:(UIImage *)image
{
    NSData *imageData= [NSKeyedArchiver archivedDataWithRootObject:image];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"badge"];
}

+ (UIImage *)badge
{
    UIImage *avatar;
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"badge"];
    if(imageData != nil)
    {
        avatar = [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
    }
    return avatar;
}

@end
