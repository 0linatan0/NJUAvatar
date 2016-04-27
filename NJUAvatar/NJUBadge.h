//
//  NJUBadge.h
//  NJUAvatar
//
//  Created by tanli on 16/4/26.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJUBadge : NSObject

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *imageName;


- (instancetype)initWithName:(NSString *)name image:(NSString*)imageName;

@end
