//
//  CollectionListController.m
//  ShareCollection
//
//  Created by lanouhn on 15-9-6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "CollectionListController.h"
#import "CollectionCell.h"
#import "CollectionDB.h"
#import "CollectionModel.h"
#import "CollectionDetailController.h"

@interface CollectionListController ()
@property (nonatomic, retain) CollectionDB *db;
@property (nonatomic, retain) NSMutableArray *dataSource;
@end

@implementation CollectionListController

- (void)dealloc {
    [_db release];
    [_dataSource release];
    [super dealloc];
}

- (CollectionDB *)db {
    if (!_db) {
        self.db = [[[CollectionDB alloc] init] autorelease];
    }
    return [[_db retain] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"列表";
    [self.tableView registerClass:[CollectionCell class] forCellReuseIdentifier:@"haha"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"收藏列表" style:UIBarButtonItemStylePlain target:self action:@selector(collectionDetail:)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haha" forIndexPath:indexPath];
    cell.firstLabel.text = [NSString stringWithFormat:@"测试数据%ld", indexPath.row];
    cell.secondLabel.text = [NSString stringWithFormat:@"%u", arc4random()];
    cell.button.tag = 100 + indexPath.row;
    [cell.button addTarget:self action:@selector(handleCollect:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//收藏
- (void)handleCollect:(UIButton *)sender {
    self.dataSource = [self.db    selectDataFromDataBase];//数据库
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 100 inSection:0];
    CollectionCell *cell = (CollectionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    for (CollectionModel *model in self.dataSource) {
        if ([model.title isEqualToString:cell.firstLabel.text] && [model.content isEqualToString:cell.secondLabel.text]) {
            [self showMessage:@"已在收藏列表"];
            return;
        }
    }
    CollectionModel *model = [[[CollectionModel alloc] initWithID:0 title:cell.firstLabel.text content:cell.secondLabel.text] autorelease];
    [self.db insertDataInDataBase:model];
    [self showMessage:@"收藏成功"];
}
//提示框
- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)collectionDetail:(UIBarButtonItem *)item {
    CollectionDetailController *detailVC = [[CollectionDetailController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

@end














