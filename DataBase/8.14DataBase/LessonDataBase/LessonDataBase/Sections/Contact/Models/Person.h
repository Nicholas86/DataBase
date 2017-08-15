//
//  Person.h
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Person : NSObject
@property (nonatomic, assign) NSInteger cID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *phone;
@property (retain, nonatomic) UIImage *image;
//提供自定义的初始化方法 -- 多参方法
- (id)initWithID:(NSInteger)cID
            name:(NSString *)name
          gender:(NSString *)gender
             age:(NSString *)age
           phone:(NSString *)phone
           image:(UIImage *)image;
+ (id)PersonWithID:(NSInteger)cID
            name:(NSString *)name
          gender:(NSString *)gender
             age:(NSString *)age
           phone:(NSString *)phone
           image:(UIImage *)image;
@end
