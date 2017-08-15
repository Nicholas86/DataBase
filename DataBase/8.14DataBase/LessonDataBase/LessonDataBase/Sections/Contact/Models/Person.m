//
//  Person.m
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)dealloc {
    [_name release];
    [_gender release];
    [_age release];
    [_phone release];
    [_image release];
    [super dealloc];
}
- (id)initWithID:(NSInteger)cID
            name:(NSString *)name
          gender:(NSString *)gender
             age:(NSString *)age
           phone:(NSString *)phone
           image:(UIImage *)image {
    self = [super init];
    if (self) {
        self.cID = cID;
        self.name = name;
        self.gender = gender;
        self.age = age;
        self.image = image;
        self.phone = phone;
    }
    return self;
    
}
+ (id)PersonWithID:(NSInteger)cID
              name:(NSString *)name
            gender:(NSString *)gender
               age:(NSString *)age
             phone:(NSString *)phone
             image:(UIImage *)image {
    return [[[Person alloc] initWithID:cID name:name gender:gender age:age phone:phone image:image] autorelease];
}
@end
