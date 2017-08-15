//
//  MenuViewController.m
//  ShareCollection
//
//  Created by lanouhn on 15-9-7.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "MenuViewController.h"
#import "ChannelMenuView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MenuViewController () <UIScrollViewDelegate, UITableViewDataSource, ChannelMenuViewDelegate>
@property (nonatomic, retain) UIScrollView *channelView;
@property (nonatomic, retain) UIScrollView *contentView;
@property (nonatomic, retain) UIView *tagView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSMutableArray *btnArray;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat currentOffset_x;
@end

@implementation MenuViewController

- (void)dealloc {
    [_channelView release];
    [_contentView release];
    [_tagView release];
    [_dataSource release];
    [_btnArray release];
    [super dealloc];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if (![user objectForKey:@"yet"]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (int i = 0; i < 10; i++) {
                [array addObject:[NSString stringWithFormat:@"频道%d", i]];
            }
            [user setObject:[NSArray arrayWithArray:array] forKey:@"yet"];
        }
        self.dataSource = [NSMutableArray arrayWithArray:[user objectForKey:@"yet"]];
    }
    return [[_dataSource retain] autorelease];
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        self.btnArray = [NSMutableArray arrayWithCapacity:1];
    }
    return [[_btnArray retain] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupChannelView];
    [self setupContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 布局
//频道栏
- (void)setupChannelView {
    self.currentPage = 0;
    self.currentOffset_x = 0;
    //创建频道栏
    self.channelView = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth - 40, 32)] autorelease];
    _channelView.backgroundColor = [UIColor whiteColor];
    _channelView.contentSize = CGSizeMake(self.dataSource.count * 60, 32);
    _channelView.showsHorizontalScrollIndicator = NO;
    _channelView.bounces = NO;
    [self.view addSubview:self.channelView];
    //添加频道按钮
    [self.btnArray removeAllObjects];
    for (int i = 0; i < self.dataSource.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(60 * i, 0, 60, 30);
        [button setTitle:self.dataSource[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeChannel:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:button];
        [self.channelView addSubview:button];
    }
    //指示条
    self.tagView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.channelView.frame) - 2, 40, 2)];
    _tagView.backgroundColor = [UIColor redColor];
    [self.channelView addSubview:_tagView];
    [_tagView release];
    //更多
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(kScreenWidth - 30, CGRectGetMinY(self.channelView.frame), 30, 30);
    moreBtn.backgroundColor = [UIColor whiteColor];
    [moreBtn setImage:[UIImage imageNamed:@"comment_arrow_down"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(handleMore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
}
//内容页
- (void)setupContentView {
    //创建内容视图
    CGFloat height = kScreenHeight - CGRectGetMaxY(self.channelView.frame) - 50;
    self.contentView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.channelView.frame) + 2, kScreenWidth, height)] autorelease];
    _contentView.delegate = self;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.bounces = NO;
    _contentView.pagingEnabled = YES;
    _contentView.contentSize = CGSizeMake(kScreenWidth * self.dataSource.count, height);
    [self.view addSubview:self.contentView];
    //添加tableView
    for (int i = 0; i < self.dataSource.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, CGRectGetHeight(self.contentView.frame)) style:UITableViewStylePlain];
        tableView.tag = 100 + i;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"haha"];
        [self.contentView addSubview:tableView];
    }
}

#pragma mark - 按钮触发方法

- (void)handleMore {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.dataSource[_currentPage] forKey:@"currentTitle"];
    
    ChannelMenuView *aView = [[ChannelMenuView alloc] initWithFrame:CGRectMake(0, - kScreenHeight, kScreenWidth, kScreenHeight)];
    aView.backgroundColor = [UIColor whiteColor];
    aView.delegate = self;
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"position.y"];
    basic.fromValue = @(aView.center.y);
    basic.toValue = @(CGRectGetHeight(aView.frame) / 2);
    basic.duration = 0.5;
    [aView.layer addAnimation:basic forKey:nil];
    aView.center = CGPointMake(aView.center.x, kScreenHeight / 2);
    [self.view addSubview:aView];
    [aView release];
}

- (void)changeChannel:(UIButton *)sender {
    self.currentPage = [self.dataSource indexOfObject:sender.currentTitle];
    self.currentOffset_x = _currentPage * kScreenWidth;
    
    self.channelView.contentOffset = CGPointMake(60 * _currentPage, 0);
    self.contentView.contentOffset = CGPointMake(kScreenWidth * _currentPage, 0);
    self.tagView.center = CGPointMake(60 * _currentPage + 30, _tagView.center.y);
    
    UITableView *tableView = (UITableView *)[self.contentView viewWithTag:100 + _currentPage];
    [tableView reloadData];
}

#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haha" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"当前频道为:%@", self.dataSource[_currentPage]];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        self.currentPage = scrollView.contentOffset.x / kScreenWidth;
        self.channelView.contentOffset = CGPointMake(60 * _currentPage, 0);
        self.tagView.center = CGPointMake(60 * _currentPage + 30, _tagView.center.y);
        
        UITableView *tableView = (UITableView *)[self.contentView viewWithTag:100 + _currentPage];
        [tableView reloadData];
    }
}

#pragma mark - ChannelMenuViewDelegate

- (void)passValue:(NSString *)value {
    NSArray *array = [NSArray arrayWithArray:self.dataSource];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.dataSource = [user objectForKey:@"yet"];
    if (![array isEqualToArray:self.dataSource]) {
        [self.channelView removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self setupChannelView];
        [self setupContentView];
    }
    
    if ([self.dataSource indexOfObject:value] < 100) {
        self.currentPage = [self.dataSource indexOfObject:[user objectForKey:@"currentTitle"]];
        self.currentOffset_x = self.currentPage * kScreenWidth;
        [self changeChannel:self.btnArray[[self.dataSource indexOfObject:value]]];
    }
}

@end















