//
//  ContentCell.h
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface ContentCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
//为cell赋值
- (void)configureCellWithMOdel:(Person *)model;
@end
