//
//  Student.h
//  UIFMDB_19
//
//  Created by lanouhn on 16/5/26.
//  Copyright © 2016年 WZ. All rights reserved.
//

#import <Foundation/Foundation.h>
//为了导入 UIImage
#import <UIKit/UIKit.h>
@interface Student : NSObject
@property(nonatomic,copy)NSString * name;
//为了区别不同,给主键
@property(nonatomic,assign)NSInteger  number;
@property(nonatomic,copy)NSString * gender;
@property(nonatomic,copy)UIImage * headerImage;
//初始化方法
-(id)initWithName:(NSString *)name number:(NSInteger)number gender:(NSString *)gender headerImage:(UIImage *)headerImage;
@end
