//
//  DataBaseManager.m
//  UIFMDB_19
//
//  Created by lanouhn on 16/5/26.
//  Copyright © 2016年 WZ. All rights reserved.
//

#import "DataBaseManager.h"
#import <FMDB.h>
//本类的延展部分,为了设置私有属性和方法
@interface DataBaseManager()
//声明一个数据库属性(等价于 SQLite 中db 指针)
//执行增删该查都使用此对象
@property(nonatomic,strong)FMDatabase * db;

    

@end
@implementation DataBaseManager
//单例方法
+ (DataBaseManager *)sharedFMDBManager{
    static DataBaseManager * manager = nil;
    //    GCD
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataBaseManager alloc]init];
//        创建表(只走一次)
        [manager createStudentTable];
//        ⚠️:此时 self 代表本类
    });
    return manager;
}
#pragma mark - 封装获取文件路径的方法
- (NSString *)searchFilePath{
//    获取 docments文件夹路径
    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    拼接上新的文件路径
    NSString * filePath = [docPath stringByAppendingPathComponent:@"Student.sqlite"];
    NSLog(@"%@",filePath);
    return filePath;
}
#pragma mark - 创建数据库的懒加载方法
- (FMDatabase * )db{
    if (!_db) {
        self.db = [FMDatabase databaseWithPath:[self searchFilePath]];
    }
    return _db;
}
#pragma mark - 创建表
- (void)createStudentTable{
//    1.打开数据库
    [self.db open];
//    2.执行创建表的 sqlite 语句
//    blob 用来修饰 data类型(需要将 Image 转成 data 存入)
    BOOL result = [self.db executeUpdate:@"create table if not exists Student(number integer primary key ,name text ,gender text ,headerImage blob)"];
    if ( result) {
        NSLog(@"创建表成功");
    }
//    关闭数据库
    [self.db close];
}
#pragma  mark - 增加数据
- (void)insertStudent:(Student *)stu{
    [self.db open];
//    添加数据局
//    ⚠️:使用 FMDB 值都为对象类型,如果遇到 NSInteger 就将其转为 NSNumber
    BOOL result = [self.db executeUpdate:@"insert into Student(number,name,gender,headerImage) values (?,?,?,?)",
        @(stu.number),stu.name,stu.gender,UIImagePNGRepresentation(stu.headerImage)];
//  ?代表站位符,是 SQLite 中的站位符,大家平时使用的%@ %ld 都是 oc 的站位符
    if (result) {
        NSLog(@"数据添加成功");
    }
    [self.db close];
}
#pragma mark - 查询数据
- (Student *)searchStudentWithNumber:(NSInteger)number{
    [self.db open];
//    创建 stu 对象,用于存储查询得到的结果
    Student * stu = [[Student alloc]init];
//    执行 sqlite 语句
//    注意 FMResultSet(存储查询结果的集合).集合中都是满足查询条件的数据.可能为一条可能为多条
    FMResultSet * set = [self.db executeQuery:@"select * from Student where number = ? ",@(number)];
//⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️   按条件查找,按条件删除,按条件更新,都是 where 关键字后面放查询条件
//    那如果查询整张表,就是 select* from Student
//    获取集合中的每一条数据
    while ([set next]) {
        NSInteger number = [set intForColumn:@"number"];
        NSString * name = [set objectForColumnIndex:1];
        NSString * gender = [set objectForColumnName:@"gender"];
        NSData * imageData = [set objectForColumnName:@"headerImage"];
//        将 data 转为 image
        UIImage * image = [UIImage imageWithData:imageData];
//        开始赋值
        stu.name = name;
        stu.gender = gender;
        stu.number = number;
        stu.headerImage = image;
    }
    [self.db close];
    return stu;
}
#pragma mark -- 修改
- (void)updateStudentWithNumber:(NSInteger)number WithStudent:(Student *)stu{
    [self.db open];
    BOOL result =[self.db executeUpdate:@"update Student set gender = ? where number = ? ",stu.gender,@(number)];
    if (result) {
        NSLog(@"修改成功");
    }
    [self.db close];
}
#pragma mark -- 删除
- (void)deleteStudentWithNumber:(NSInteger)number{
    [self.db open];
    BOOL result = [self.db executeUpdate:@"delete from Student where number = ?",@(number)];
    if (result) {
        NSLog(@"删除成功");
    }
    [self.db close];
}
#pragma mark --线程安全
- (void)threadSafeAction{
//    线程安全是针对多个线程同时访问数据库时,可能会出现的资源争夺或者数据重复访问等问题时候,我们可以设置数据库访问队列,但是并不是每次都需要设置.(看工程的开发情况)
//    FMDataBaseQueue, 这个类就是FMDB专门封装的一个解决线程安全问题的类,但是此类本身不是一个队列(队列是 NSOperationQueue),只是这个类中封装了一个同步队列,那加入该队列的任务只能一个执行,可保证数据访问的安全性.
//  1.根据数据库路径创建一个 FMDataBaseQueue 对象
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:[self searchFilePath]];
//    2.打开数据库
    [self.db open];
//    3.向 FMDatabaseQueue中添加你要执行的操作就行了(比如增,该等)
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//       插入数据
        BOOL result = [db executeUpdate:@"insert into Student (number,name,gender,headerImage) values (?,?,?,?)",@123,@"hahha",@"girl",nil];
//        线程安全其实就是要把执行的操作放在这里执行即可,因为这里是同步队列的管理范围
//        而且,FMDATABaseQueue 按照路径创建的对象也只有一个(因为数据路径唯一);
        if (result) {
            NSLog(@"添加成功");
        }else{
//            如果添加失败, rollBack 能让命令再次重置(执行)一次
            *rollback = YES;
            return ;//必须要写,否则死循环
        }
    }];
    [self.db close];
}

@end












