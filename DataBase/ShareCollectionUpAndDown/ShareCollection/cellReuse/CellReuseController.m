//
//  CellReuseController.m
//  ShareCollection
//
//  Created by lanouhn on 15-9-7.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "CellReuseController.h"

@interface CellReuseController ()
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation CellReuseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"haha"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haha" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    NSIndexPath *index = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    if (indexPath == index) {
        cell.textLabel.backgroundColor = [UIColor greenColor];
        cell.textLabel.highlighted = YES;
        
    } else {
        cell.textLabel.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.textLabel.highlighted = YES;
    [self.tableView reloadData];
}

@end
