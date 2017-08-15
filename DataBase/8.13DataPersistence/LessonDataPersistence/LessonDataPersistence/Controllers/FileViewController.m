//
//  FileViewController.m
//  LessonDataPersistence
//
//  Created by Frank on 15/8/6.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "FileViewController.h"

@interface FileViewController ()
@property (retain, nonatomic) IBOutlet UITextField *tf1;
@property (retain, nonatomic) IBOutlet UITextField *tf2;
@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle action
//字符串写入文件 -- 将第一个输入框内容写入文件
- (IBAction)stringWriteToFile:(UIButton *)sender {
    //1.获取文件路径
    NSString *filePath = [self stringFilePath];
    //2.将内容写入文件
    BOOL isSuccess = [self.tf1.text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", isSuccess ? @"字符串写入成功" : @"字符串写入失败");
}
//字符串读取文件 -- 获取文件内容,让第二个输入框显示
- (IBAction)stringReadFromFile:(UIButton *)sender {
    //1.获取文件路径
    NSString *filePath = [self stringFilePath];
    //2.根据文件路径创建字符串对象
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.tf2.text = str;
    
}
//做数据持久化 ,将数据存储到文件中,文件放到沙盒文件夹下的Documents文件夹下
//获取字符串操作文件路径
- (NSString *)stringFilePath {
    //1.获取Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接文件路径
    //NSString *filePath = [documentsPath stringByAppendingString:@"/string.txt"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"string.txt"];
    return filePath;
}
//数组写入文件 -- 将两个输入框内容写入文件
- (IBAction)arrayWriteToFile:(UIButton *)sender {
    //1.获取Documents文件路径
    NSString *filePath = [self arrayFilePath];
    NSArray *array = @[self.tf1.text, self.tf2.text];
    //2.将数组内容写入文件
    BOOL isSuccess = [array writeToFile:filePath atomically:YES];
    NSLog(@"%@", isSuccess ? @"数组写入成功" : @"数组写入失败");
}
//数组读取文件 -- 第一个输入框显示第二个输入框的内容,第二个输入框显示第一个输入框的内容
- (IBAction)arrayReadFromFile:(UIButton *)sender {
    //1.获取文件路径
    NSString *filePath = [self arrayFilePath];
    //2.根据文件路径创建数组对象
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    self.tf1.text = array[1];
    self.tf2.text = array.firstObject;
}
//获取数组操作文件路径
- (NSString *)arrayFilePath {
    //1.获取Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接上操作文件路径
    return [documentsPath stringByAppendingPathComponent:@"array.text"];
}
//字典写入文件 -- 将两个输入框内容写入文件
- (IBAction)dictionaryWriteToFile:(UIButton *)sender {
    //1.获取Documents文件路径
    NSString *documentsPath = [self dictionaryFilePath];
    NSDictionary *dictionary = @{@"tf1":self.tf1.text,
                                 @"tf2":self.tf2.text};
    //2.将字典内容写入文件
    BOOL isSuccess = [dictionary writeToFile:documentsPath atomically:YES];
    NSLog(@"%@", isSuccess ? @"字典写入成功":@"字典写入失败");
    
}
//字典读取文件 -- 第一个输入框显示第二个输入框的内容,第二个输入框显示第一个输入框的内容
- (IBAction)dictionaryReadFromFile:(UIButton *)sender {
    //1.获取Documents文件夹路径
    NSString *documentsPath = [self dictionaryFilePath];
    //2.根据文件路径显示指定内容
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:documentsPath];
    self.tf1.text = dictionary[@"tf2"];
    self.tf2.text = dictionary[@"tf1"];
}
//获取字典操作文件路径
- (NSString *)dictionaryFilePath {
    //1.先获取Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接上操作文件路径
    return [documentsPath stringByAppendingPathComponent:@"dictionary.text"];
}
//二进制数据写入文件 -- 将第一个输入框内容写入文件
- (IBAction)dataWriteToFile:(UIButton *)sender {
    //1.获取documents文件夹路径
    NSString *documentsPath = [self dataFilePath];
    //2.将二进制数据写入文件
    NSData *data = [self.tf1.text dataUsingEncoding:NSUTF8StringEncoding];
    BOOL isSuccess = [data writeToFile:documentsPath atomically:YES];
    NSLog(@"%@", isSuccess ? @"二进制数据写入成功" : @"二进制数据写入失败");
}

//二进制数据读取文件 -- 第二个输入框显示第一个输入框内容
- (IBAction)dataReadFromFile:(UIButton *)sender {
    //获取文件路径
    NSString *filePath = [self dataFilePath];
    //2.根据文件路径创建NSData对象
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.tf2.text = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}
//获取二进制数据操作文件路径
- (NSString *)dataFilePath {
    //1.先获取Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接上操作文件路径
    return [documentsPath stringByAppendingPathComponent:@"data.text"];
}
- (void)dealloc {
    [_tf1 release];
    [_tf2 release];
    [super dealloc];
}
/*
 文件读写支持的类:字符串,数组,字典,二进制数据,(包含可变和不可变) 这些类具有写入文件的方法和通过文件读取内容的方法
 写入文件:
 字符串:writeToFile: atomically: encoding: error:nil
 其他类:writeToFile: atomically:
 
 读取文件:[NSString stringWithContentsOfFile: encoding: error:nil]
 数组: [NSArray arrayWithContentsOfFile:]
 字典:[NSDictionary dictionaryWithContentsOfFile:]
 二进制数据:[NSData dataWithContentsOfFile:]
 
 VIP :当使用数组,字典写入文件时,必须保证其中的元素也是这四种类型之一
 
 文件读写的优点:写入和读写简单
 文件读写的缺点:有局限性,仅支持上述四种类型数据,数据操作不灵活,新的内容会将之前的内容覆盖,而且无法对其中的一条数据进行灵活的增删改操作
 */
@end







