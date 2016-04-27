//
//  NJUBadgeTableViewCell.m
//  NJUAvatar
//
//  Created by tanli on 16/4/26.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import "NJUBadgeTableViewCell.h"

@implementation NJUBadgeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.badgeName.text = @"hah";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillContentWithBadge:(NJUBadge *)badge
{
    self.badgeName.text = badge.name;
    self.badgeImage.image = [UIImage imageNamed:badge.imageName];
}

@end
