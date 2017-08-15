//
//  Person.m
//  LessonDataPersistence
//
//  Created by lanouhn on 15/8/13.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "Person.h"

@implementation Person
//当对Person对象进行归档时,会自动进行该方法,对每一个实例变量进行归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:@(_age) forKey:@"age"];
    //归档时只能归档对象
}
//当对Person对象进行反归档时,会自动进行该方法,对每一个实例变量进行反归档
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        //反归档实例变量
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.age = [[aDecoder decodeObjectForKey:@"age"] integerValue];
    }
    return self;
}
-  (void)dealloc {
    [_name release];
    [_gender release];
    [super dealloc];
}
@end
