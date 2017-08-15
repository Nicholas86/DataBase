//
//  CollectionDetailController.m
//  ShareCollection
//
//  Created by lanouhn on 15-9-6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "CollectionDetailController.h"
#import "CollectionDB.h"
#import "CollectionCell.h"
#import "CollectionModel.h"

@interface CollectionDetailController ()
@property (nonatomic, retain) CollectionDB *db;
@property (nonatomic, retain) NSMutableArray *dataSource;
@end

@implementation CollectionDetailController

- (void)dealloc {
    [_db release];
    [super dealloc];
}

- (CollectionDB *)db {
    if (!_db) {
        self.db = [[CollectionDB alloc] init];
    }
    return [[_db retain] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[CollectionCell class] forCellReuseIdentifier:@"haha"];
    
    self.dataSource = [self.db selectDataFromDataBase];
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
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haha" forIndexPath:indexPath];
    CollectionModel *model = self.dataSource[indexPath.row];
    cell.firstLabel.text = model.title;
    cell.secondLabel.text = model.content;
    cell.button.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionModel *model = self.dataSource[indexPath.row];
    [self.db deleteDataFromDataBase:model.ID];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end



