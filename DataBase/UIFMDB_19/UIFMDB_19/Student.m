//
//  Student.m
//  UIFMDB_19
//
//  Created by lanouhn on 16/5/26.
//  Copyright © 2016年 WZ. All rights reserved.
//

#import "Student.h"

@implementation Student
-(id)initWithName:(NSString *)name number:(NSInteger)number gender:(NSString *)gender headerImage:(UIImage *)headerImage{
    if (self = [super init]) {
        self.name = name;
        self.number = number;
        self.gender = gender;
        self.headerImage = headerImage;
    }
    return self;
}

@end
