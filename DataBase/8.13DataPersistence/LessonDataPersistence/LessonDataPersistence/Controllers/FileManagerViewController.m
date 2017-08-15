//
//  FileManagerViewController.m
//  LessonDataPersistence
//
//  Created by Frank on 15/8/6.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "FileManagerViewController.h"

@interface FileManagerViewController ()

@end

@implementation FileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - handle action
//创建文件夹 -- 在Caches文件夹创建Images文件夹
- (IBAction)createFile:(UIButton *)sender {
    //1/获取文件夹路径
    NSString *filePath = [self imagesFilePath];
    //2创建文件管理类对象
    NSFileManager *manager = [NSFileManager defaultManager];
    //3.创建文件夹
   BOOL isSuccess = [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSLog(@"%@", isSuccess ? @"创建成功" : @"创建失败");
    
}
//删除文件夹 -- 将Images文件夹删除
- (IBAction)removeFile:(UIButton *)sender {
   //1.获取文件夹路径
    NSString *filePath = [self imagesFilePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager removeItemAtPath:filePath error:nil];
    NSLog(@"%@", isSuccess ? @"成功" : @"失败");
}
//拷贝文件 -- 将包中的NB.plist文件拷贝到沙盒中Images文件夹下
- (IBAction)copyFile:(UIButton *)sender {
    //1.获取包中NB.plist文件路径
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"NB.plist" ofType:nil];
    //2.获取沙盒中Images文件下NB.plist文件路径(目的路径)
    NSString *desPath = [[self imagesFilePath] stringByAppendingPathComponent:@"NB.plist"];
    //3.创建文件管理类对象
    NSFileManager *manager = [NSFileManager defaultManager];
    //4.判断文件是否存在,不存在,则拷贝
    if (![manager fileExistsAtPath:desPath]) {
        BOOL isSuccess =[manager copyItemAtPath:sourcePath toPath:desPath error:nil];
        NSLog(@"%@", isSuccess ? @"拷贝成功" : @"拷贝失败");
    }
    
}
//移动文件 -- 将Images文件夹下NB.plist文件移动到Documents文件夹下
- (IBAction)moveFile:(UIButton *)sender {
    //1.获取Images文件夹下NB.plist文件地址(源地址)
    NSString *sourcePath = [[self imagesFilePath] stringByAppendingPathComponent:@"NB.plist"];
    //2.获取Documents文件夹NB.plist文件路径(目的地址)
    NSString *destPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"NB.plist"];
    //3.创建文件管理类对象
    NSFileManager *manager = [NSFileManager defaultManager];
    //4.判断文件是否存在,不存在则移动
    if (![manager fileExistsAtPath:destPath]) {
        BOOL isSuccess = [manager moveItemAtPath:sourcePath toPath:destPath error:nil];
        NSLog(@"%@", isSuccess ? @"移动成功" : @"移动失败");
    }
    
}
//获取文件夹属性 -- 获取Documents文件夹属性,获取文件大小
- (IBAction)fileAttributes:(UIButton *)sender {
    //1.获取Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.创建文件管理类对象,获取属性
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary *dic = [manager attributesOfItemAtPath:documentsPath error:nil];
    NSLog(@"dic = %@", dic);
    NSNumber *size = dic[@"NSFileSize"];
    NSLog(@"%@", size); //KB
}
//获取Images文件夹路径
- (NSString *)imagesFilePath {
    //1.获取Caches文件夹路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接上Images文件夹路径
    return [cachesPath stringByAppendingPathComponent:@"Images"];
}
@end
