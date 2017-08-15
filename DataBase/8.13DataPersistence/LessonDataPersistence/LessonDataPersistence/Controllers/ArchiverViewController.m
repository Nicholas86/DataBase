//
//  ArchiverViewController.m
//  LessonDataPersistence
//
//  Created by Frank on 15/8/6.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "ArchiverViewController.h"
#import "Person.h"
@interface ArchiverViewController ()
@property (retain, nonatomic) IBOutlet UITextField *tf1;
@property (retain, nonatomic) IBOutlet UITextField *tf2;

@end

@implementation ArchiverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 10; i++) {
        Person *per = [[[Person alloc] init] autorelease];
        [arr addObject:per];
    }
    //如果想持久化所有的Person对象,我们只需要对数组arr进行归档操作即可
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - handle action
/*
 归档和反归档:针对于复杂对象,比如自定义类的对象,来进行数据持久化操作
 归档和反归档相当于转化工具.
 写入过程:
 自定义对象 -- 使用归档工具 -- NSData对象 -- 写入文件
 读取过程:
 文件 -- NSData对象 -- 使用反归档工具 -- 自定义对象
 */
//归档文件
- (IBAction)handleArchiver:(UIButton *)sender {
  //1.创建自定义对象
    Person *per1 = [[Person alloc] init];
    per1.name = self.tf1.text;
    per1.gender = @"男";
    per1.age = 18;
    Person *per2 = [[Person alloc] init];
    per2.name = self.tf2.text;
    per2.gender = @"女";
    per2.age = 30;
    //2.创建归档工具,将自定义对象转化成NSData对象
    NSMutableData *mData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData] autorelease];
    //3.对自定义对象进行归档,将数据写入到mData中
    [archiver encodeObject:per1 forKey:@"p1"];
    [archiver encodeObject:per2 forKey:@"p2"];
    //4.结束归档之后再进行归档操作,则无效
    [archiver finishEncoding];
    //5.将mData数据写入本地文件,进行数据持久化
    BOOL isSuccess = [mData writeToFile:[self archiverFilePath] atomically:YES];
    NSLog(@"%@", isSuccess ? @"成功" : @"失败");
    [per1 release];
    [per2 release];
    
}
//反归档文件
- (IBAction)handleUnarchiver:(UIButton *)sender {
    //1.根据文件路径创建NSData对象
    NSData *data = [NSData dataWithContentsOfFile:[self archiverFilePath]];
    //2.创建反归档工具,将NSData转化成Person对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //3.反归档操作 -- 获取对应的Person对象
    Person *per1 = [unarchiver decodeObjectForKey:@"p1"];
    Person *per2 = [unarchiver decodeObjectForKey:@"p2"];
    //4.结束反归档
    [unarchiver finishDecoding];
    [unarchiver release];
    //显示数据
    self.tf1.text = per2.name;
    self.tf2.text = per1.name;
    
}
- (void)dealloc {
    [_tf1 release];
    [_tf2 release];
    [super dealloc];
}
- (NSString *)archiverFilePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentsPath stringByAppendingPathComponent:@"archiver.data"];
}
@end
