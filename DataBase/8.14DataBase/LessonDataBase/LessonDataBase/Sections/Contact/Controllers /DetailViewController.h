//
//  DetailViewController.h
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@protocol DetailViewControllerDelegate <NSObject>
- (void)passPerson:(Person *)modifyPer;
@end

@interface DetailViewController : UIViewController
@property (retain, nonatomic) Person *per;
@property (assign, nonatomic) id<DetailViewControllerDelegate> delegate;
@end
