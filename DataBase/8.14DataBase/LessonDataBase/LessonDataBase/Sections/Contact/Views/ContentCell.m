//
//  ContentCell.m
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell
- (void)dealloc {
    [_avatarImage release];
    [_nameLabel release];
    [_phoneLabel release];
    [super dealloc];
}
- (void)configureCellWithMOdel:(Person *)model {
    self.avatarImage.image = model.image;
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.phone;
}
@end
