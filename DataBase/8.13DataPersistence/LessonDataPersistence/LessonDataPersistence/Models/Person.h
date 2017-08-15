//
//  Person.h
//  LessonDataPersistence
//
//  Created by lanouhn on 15/8/13.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
//如果要对一个对象进行归档操作,该类必须服从NSCoding
@interface Person : NSObject <NSCoding>
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *gender;
@property (assign, nonatomic) NSInteger age;
@end
