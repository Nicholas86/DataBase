//
//  RootViewController.m
//  ShareCollection
//
//  Created by lanouhn on 15-9-6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "RootViewController.h"
#import "CollectionListController.h"
#import "CellReuseController.h"
#import "MenuViewController.h"

@interface RootViewController ()
@property (nonatomic, retain) NSArray *titles;
@end

@implementation RootViewController

- (void)dealloc {
    [_titles release];
    [super dealloc];
}

- (NSArray *)titles {
    if (!_titles) {
        self.titles = @[@"收藏功能", @"cell重用", @"下拉菜单"];
    }
    return [[_titles retain] autorelease];
}

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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haha" forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            CollectionListController *listVC = [[CollectionListController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:listVC animated:YES];
            [listVC release];
        }
            break;
        case 1: {
            CellReuseController *reuseVC = [[CellReuseController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:reuseVC animated:YES];
            [reuseVC release];
        }
            break;
        case 2: {
            MenuViewController *menuVC = [[MenuViewController alloc] init];
            [self.navigationController pushViewController:menuVC animated:YES];
            [menuVC release];
        }
            break;
        default:
            break;
    }
}

@end





