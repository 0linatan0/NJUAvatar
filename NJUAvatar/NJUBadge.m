//
//  NJUBadge.m
//  NJUAvatar
//
//  Created by tanli on 16/4/26.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import "NJUBadge.h"

@implementation NJUBadge

- (instancetype)initWithName:(NSString *)name image:(NSString*)imageName
{
    self = [super init];
    if (self)
    {
        _name = name;
        _imageName = imageName;
    }
    return self;
}


@end
