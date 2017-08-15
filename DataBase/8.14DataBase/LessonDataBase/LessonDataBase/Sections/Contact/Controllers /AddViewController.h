//
//  AddViewController.h
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
//定义协议
@protocol AddViewControllerDelegate <NSObject>
- (void)addPerson:(Person *)person;
@end
@interface AddViewController : UIViewController
//定义代理属性 -- 存储代理对象
@property (assign, nonatomic) id<AddViewControllerDelegate> dealegate;
@end
