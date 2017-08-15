//
//  ContactListController.m
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import "ContactListController.h"
#import "UIColor+Additon.h"
#import "ContentCell.h" //自定义cell类
#import "FMDatabase.h" //第三方数据库操作类
#import "AddViewController.h" //添加联系人界面
#import "DetailViewController.h" //详情界面
@interface ContactListController () <AddViewControllerDelegate, DetailViewControllerDelegate>
@property (nonatomic, retain) FMDatabase *db; //存放数据库操作类对象
@property (nonatomic, retain) NSMutableArray *dataSource; //存储所有的联系人对象
@end

@implementation ContactListController
- (void)dealloc {
    [_dataSource release];
    [_db release];
    [super dealloc];
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return [[_dataSource retain] autorelease];
}
//当列表界面将要出现时,让tableView读取最新的数据
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//配置导航条内容
- (void)configureNavigationBarContent {
    //导航条颜色
    self.navigationController.navigationBar.barTintColor = [UIColor lightGreenColor];
    //导航条内容渲染颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //导航条标题的颜色
    NSDictionary *attribute = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)setupTabelView {
    //页眉
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.text = [NSString stringWithFormat:@"总共有%lu个联系人", [self.dataSource count]];
    self.tableView.tableHeaderView = aLabel;
    [aLabel release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建数据库 -- 存储数据库文件(通过数据库操作对象)
    [self creatDataBase];
    //2.创建表 -- 存储数据
    [self creatTableInDataBase];
    //3.读取数据
    [self selectDataFromDataBase];
    
    [self configureNavigationBarContent];
    [self setupTabelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deque" forIndexPath:indexPath];
    //从数组中取出Model对象,给cell赋值
    [cell configureCellWithMOdel:self.dataSource[indexPath.row]];
    return cell;
}

//提交编辑操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.从数据库中删除数据
    Person *per = self.dataSource[indexPath.row];
    [self deleteDataFromDataBase:per.cID];
    //2.修改数据源
    [self.dataSource removeObjectAtIndex:indexPath.row];
    //3.修改界面
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self setupTabelView];
}

//当通过Storyboard完成界面跳转时,该方法就会触发
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"add"]) {
        //列表界面 -- 添加联系人界面
        AddViewController *addVC = [segue.destinationViewController viewControllers][0];
        addVC.dealegate = self;
    } else {
        //列表界面 -- 详情界面
        DetailViewController *detailVC = segue.destinationViewController;
        NSInteger index = [self.tableView indexPathForCell:sender].row;
        detailVC.per = self.dataSource[index];
        detailVC.delegate = self;
    }
}
#pragma mark -- handle DataaBase
//创建数据库 -- 数据库中存放表
- (void)creatDataBase {
    //db -- 数据库操作类对象 -- 指向本地的数据库
    self.db = [FMDatabase databaseWithPath:[self getDataBasePath]];
}
//创建表 -- 表用来存储数据 -- 一条数据就是一个完整的联系人
- (void)creatTableInDataBase {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 -- 创建表
    //executeUpdate:除了查询指令,其他都用这个
    BOOL isSuccess = [self.db executeUpdate:@"create table if not exists Contact(c_id integer primary key autoincrement, c_name text, c_gender text, c_age text, c_image blob, c_phone text)"]; //blob 二进制数据(C语言中)
    NSLog(@"%@", isSuccess ? @"创建表成功" : @"创建表失败");
    //3.关闭数据库
    [self.db close];
    
}
//往数据库中插入一条新的数据
- (void)insertDataInDataBase:(Person *)per {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 -- 往数据库中插入一条数据
    NSData *data = UIImagePNGRepresentation(per.image);
    BOOL isSuccess = [self.db executeUpdate:@"insert into Contact(c_name, c_gender, c_age, c_image, c_phone) values(?,?,?,?,?)", per.name, per.gender, per.age, data, per.phone];
    NSLog(@"%@", isSuccess ? @"插入成功" : @"插入失败");
    //需要做一步数据的同步处理,同步唯一标识
    per.cID = self.db.lastInsertRowId;
    //3.关闭数据库
    [self.db close];
    [self setupTabelView];
}
//查询数据方法 -- 从数据库中读取数据
- (void)selectDataFromDataBase {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 -- 查询所有数据
    FMResultSet *result = [self.db executeQuery:@"select * from Contact"];
    while ([result next]) {
        //读取一条数据每个字段的值
        NSInteger ID = [result intForColumn:@"c_id"];
        NSString *name = [result stringForColumn:@"c_name"];
        NSString *gender = [result stringForColumn:@"c_gender"];
        NSString *age = [result stringForColumn:@"c_age"];
        NSString *phone = [result stringForColumn:@"c_phone"];
        NSData *data = [result dataForColumn:@"c_image"];
        UIImage *image = [UIImage imageWithData:data];
        //将读取到的数据封装成Person对象,存储到数组中
        Person *per = [Person PersonWithID:ID name:name gender:gender age:age phone:phone image:image];
        [self.dataSource addObject:per];
    }
    //3.关闭数据库
    [self.db close];

}
//从数据库中删除一条数据
- (void)deleteDataFromDataBase:(NSInteger)cID {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据 -- 删除一条数据
    BOOL isSuccess = [self.db executeUpdate:@"delete from Contact where c_id = ?", @(cID)];
    NSLog(@"%@", isSuccess ? @"删除成功" : @"删除失败");
    //3.关闭数据库
    [self.db close];
    [self setupTabelView];
}
//更新一条数据
- (void)updataDataInDataBase:(Person *)per {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 -- 更新数据库
    NSData *data = UIImagePNGRepresentation(per.image);
    BOOL isSuccess = [self.db executeUpdate:@"update Contact set c_name = ?, c_gender = ?, c_phone = ?, c_image = ? where c_id = ?", per.name, per.gender, per.phone, data, @(per.cID)];
    NSLog(@"%@", isSuccess ? @"更新成功" : @"更新失败");
    //3.关闭数据库
    [self.db close];
    [self setupTabelView];
    
}
//获取数据库文件路径的方法
- (NSString *)getDataBasePath {
    //1.获取Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接上数据库文件路径
    return [documentsPath stringByAppendingPathComponent:@"LO.sqlite"];
}
//添加联系人界面回调方法 -- 用来添加联系人
- (void)addPerson:(Person *)person {
    //1.修改内存,数组添加新的联系人对象
    [self.dataSource addObject:person];
    //2.将数据插入到数据库中,做数据持久化
    [self insertDataInDataBase:person];
}
/*
 更新思路:点击cell时,将对应的联系人对象传到详情页面,展示数据,当第二个界面修改完信息之后,通过代理回调将修改之后的Person对象传到第一个界面,进行数据更新.
 
 */
//执行协议中的方法
- (void)passPerson:(Person *)modifyPer {
    if (![modifyPer.name length] && ![modifyPer.phone length]) {
        [self deleteDataFromDataBase:modifyPer.cID];
        [self.dataSource removeAllObjects];
        [self selectDataFromDataBase];
        [self setupTabelView];
    } else {
        [self updataDataInDataBase:modifyPer];
    }

}

@end
