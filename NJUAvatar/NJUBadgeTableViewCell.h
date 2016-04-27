//
//  NJUBadgeTableViewCell.h
//  NJUAvatar
//
//  Created by tanli on 16/4/26.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJUBadge.h"

@interface NJUBadgeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *badgeImage;

@property (weak, nonatomic) IBOutlet UILabel *badgeName;

- (void)fillContentWithBadge:(NJUBadge *)badge;

@end
