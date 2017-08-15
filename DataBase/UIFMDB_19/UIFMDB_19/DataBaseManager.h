//
//  DataBaseManager.h
//  UIFMDB_19
//
//  Created by lanouhn on 16/5/26.
//  Copyright © 2016年 WZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
@interface DataBaseManager : NSObject
//单例方法
+(DataBaseManager *)sharedFMDBManager;
//⚠️数据库的创建和打开,以及表的创建,外界可以不访问,我们封装成私有方法
//添加数据
- (void)insertStudent:(Student *)stu;
//删除数据
- (void)deleteStudentWithNumber:(NSInteger)number;
//修改
- (void)updateStudentWithNumber:(NSInteger )number WithStudent:(Student *)stu;
//查询操作
- (Student *)searchStudentWithNumber:(NSInteger)number;
//关于线程安全的方法
- (void)threadSafeAction;

@end
