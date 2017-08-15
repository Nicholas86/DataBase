//
//  AppDelegate.m
//  LessonDataPersistence
//
//  Created by Frank on 15/8/6.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "AppDelegate.h"
/*
 数据持久化:将数据永久性的存储,之前数据存储在内存中,程序退出之后,内容也被清除
 数据持久化的本质:将数据存储到文件中放到本地
 */
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //打印应用程序包路径 -- 包含应用程序加载所需资源
    //NSBundle -- 操作应用程序包 -- readonly
    NSString *boundFilePath = [[NSBundle mainBundle] bundlePath];
    NSLog(@"boundFilePath = %@", boundFilePath);
    //获取包中资源路径 -- 波波图片
    //01:资源名字 02:资源类型 ,可以分开写,也可以统一写,如统一写后那后面就不要再写,直接置nil,(如果01包含了资源类型,02给nil即可)
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"320x49" ofType:@"png"];
    NSLog(@"%@", filePath);
    //打印沙盒文件夹路径 -- 沙盒文件夹是针对于安装到移动终端的每一个应用单独生成的文件夹,存储用户的个性设置,每个用户内容不同,readwrite
    NSString *homePath = NSHomeDirectory();
    NSLog(@"homePath = %@", homePath);
    /*
     沙盒文件夹子文件夹:
     Documents:存放数据持久化文件,比如:通讯录信息,备份时也只备份该文件夹内容,该文件夹内容不能过大,否则无法上传到AppStore.
     Library:
          Caches:存放缓存文件夹.下载的视频,图片,音频小说都在该文件夹中
          Preferences:存放用户偏好设置,比如:存储用户的用户名和密码
     Tmp:存放临时文件,比如:下载的zip包,解压之后将zip包删除,将解压内容移到Caches文件夹中
     VIP:开发人员是没有权限删除系统创建的文件夹的,但是可以删除自己创建的文件夹
     */
    //1.获取Documents文件夹路径
    //01:获取那个文件夹路径 -- 64行
    //02:在哪个域中进行查找 -- 用户域
    //03:是否显示详细路径,绝对路径/相对路径
    /*
     该方法最早用于OS X系统获取文件路径,后期适用于iOS平台,因为在OS X下可以存在多个用户,所以会获取到所有用户的文件夹路径,返回一个数组存储,但是iOS平台就只有一个用户
     */
    NSString *docmentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"docmentsPath = %@", docmentsPath);
    //2.获取Caches文件夹路径
    NSString *CachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"CachesPath = %@", CachesPath);
    //3.操作Preferences文件夹,存储数据 -- NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //存储用户名和密码
    [defaults setObject:@"Frank" forKey:@"name"];
    [defaults setObject:@"1234567" forKey:@"pwd"];
    //存储BOOL类型数据
    [defaults setObject:@"YES" forKey:@"FirsrEntry"];
    //立即同步 -- 立即将数据写入到本地文件
    [defaults synchronize];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
