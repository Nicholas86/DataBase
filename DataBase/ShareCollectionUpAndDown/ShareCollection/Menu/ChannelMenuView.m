//
//  ChannelMenuView.m
//  ShareCollection
//
//  Created by lanouhn on 15-9-7.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ChannelMenuView.h"

#define kInterSpacing 10
#define kLineSpacing 10
#define kMarginLeft 10
#define kMarginTop 10
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kWidth_button  (kScreenWidth - 2 * kMarginLeft - kInterSpacing * 3) / 4
#define kHeightLabel 40

@interface ChannelMenuView ()
@property (nonatomic, retain) NSMutableArray *upArray;
@property (nonatomic, retain) NSMutableArray *downArray;
@property (nonatomic, retain) UIView *upView;
@property (nonatomic, retain) UIView *downView;
@property (nonatomic) BOOL isSelected;
@end

@implementation ChannelMenuView

- (void)dealloc {
    [_upArray release];
    [_downArray release];
    [_upView release];
    [_downView release];
    [super dealloc];
}

- (NSMutableArray *)upArray {
    if (!_upArray) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        self.upArray = [NSMutableArray arrayWithArray:[user objectForKey:@"yet"]];
    }
    return [[_upArray retain] autorelease];
}

- (NSMutableArray *)downArray {
    if (!_downArray) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if (![user objectForKey:@"remain"]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (int i = 10; i < 20; i++) {
                [array addObject:[NSString stringWithFormat:@"频道%d", i]];
            }
            [user setObject:[NSArray arrayWithArray:array] forKey:@"remain"];
        }
        self.downArray = [NSMutableArray arrayWithArray:[user objectForKey:@"remain"]];
    }
    return [[_downArray retain] autorelease];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUpLabel];
        [self setupUpButton];
        [self setupDownLabel];
        [self setupDownButton];
    }
    return self;
}

#pragma mark - 布局
//布局上面的视图
- (void)setupUpLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kHeightLabel)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = @"切换栏目";
    [self addSubview:label];
    [label release];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth - 100, CGRectGetMinY(label.frame), 50, kHeightLabel);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitle:@"完成" forState:UIControlStateSelected];
    [deleteBtn addTarget:self action:@selector(handleDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor lightGrayColor];
    [backBtn setImage:[UIImage imageNamed:@"audionews_list_arrow_up@2x"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(kScreenWidth - 50, CGRectGetMinY(label.frame), 50, kHeightLabel);
    [backBtn addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
}
//布局上面的按钮
- (void)setupUpButton {
    self.upView = [[[UIView alloc] initWithFrame:CGRectMake(0, 64 + kHeightLabel, kScreenWidth, kScreenHeight / 2 - 64 - kHeightLabel)] autorelease];
    [self addSubview:_upView];

    int y = kLineSpacing;
    for (int i = 0; i < self.upArray.count / 4 + 1; i++) {
        int x = kMarginLeft;
        for (int j = 0; j < 4; j++) {
            if (i * 4 + j < self.upArray.count) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.frame = CGRectMake(x, y, kWidth_button, 30);
                [button setTitle:self.upArray[i * 4 + j] forState:UIControlStateNormal];
                button.tintColor = [UIColor blackColor];
                button.layer.borderColor = [UIColor grayColor].CGColor;
                button.layer.borderWidth = 0.5;
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = YES;
                [button addTarget:self action:@selector(handleUpBtn:) forControlEvents:UIControlEventTouchUpInside];
                [_upView addSubview:button];
                
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                if ([button.currentTitle isEqualToString:[user objectForKey:@"currentTitle"]]) {
                    button.tintColor = [UIColor redColor];
                }
                
                x += kWidth_button + kInterSpacing;
            }
        }
        y += 30 + kLineSpacing;
    }
}
//布局下面的视图
- (void)setupDownLabel {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0,  kScreenHeight / 2, kScreenWidth, kHeightLabel)] autorelease];
    label.text = @"点击添加更多栏目";
    label.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:label];
}
//布局下面的按钮
- (void)setupDownButton {
    self.downView = [[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.upView.frame) + kHeightLabel, kScreenWidth, kScreenHeight / 2 - kHeightLabel)] autorelease];
    [self addSubview:_downView];

    int y = kLineSpacing;
    for (int i = 0; i < self.downArray.count / 4 + 1; i++) {
        int x = kMarginLeft;
        for (int j = 0; j < 4; j++) {
            if (i * 4 + j < self.downArray.count) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.frame = CGRectMake(x, y, kWidth_button, 30);
                [button setTitle:self.downArray[i * 4 + j] forState:UIControlStateNormal];
                button.tintColor = [UIColor blackColor];
                button.layer.borderColor = [UIColor grayColor].CGColor;
                button.layer.borderWidth = 0.5;
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = YES;
                [button addTarget:self action:@selector(handleDownBtn:) forControlEvents:UIControlEventTouchUpInside];
                [_downView addSubview:button];
                x += kWidth_button + kInterSpacing;
            }
        }
        y += 30 + kLineSpacing;
    }
}

#pragma mark - 按钮相关方法

- (void)handleDelete:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isSelected = sender.selected;
}

- (void)handleBack {
    if ([self.delegate respondsToSelector:@selector(passValue:)]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [self.delegate passValue:[user objectForKey:@"currentTitle"]];
    }
    [self removeFromSuperview];
}

- (void)handleUpBtn:(UIButton *)sender {
    if (_isSelected) {
        if (self.upArray.count > 1) {
            [self.upArray removeObject:sender.currentTitle];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:[NSArray arrayWithArray:self.upArray] forKey:@"yet"];
            [self.upView removeFromSuperview];
            [self setupUpButton];
            
            [self.downArray addObject:sender.currentTitle];
            [user setObject:[NSArray arrayWithArray:self.downArray] forKey:@"remain"];
            [self.downView removeFromSuperview];
            [self setupDownButton];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(passValue:)]) {
            [self.delegate passValue:sender.currentTitle];
        }
        [self removeFromSuperview];
    }
}

- (void)handleDownBtn:(UIButton *)sender {
    if (self.upArray.count < 20) {
        [self.upArray addObject:sender.currentTitle];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:[NSArray arrayWithArray:self.upArray] forKey:@"yet"];
        [self.upView removeFromSuperview];
        [self setupUpButton];
        
        [self.downArray removeObject:sender.currentTitle];
        [user setObject:[NSArray arrayWithArray:self.downArray] forKey:@"remain"];
        [self.downView removeFromSuperview];
        [self setupDownButton];
    }
}

@end
