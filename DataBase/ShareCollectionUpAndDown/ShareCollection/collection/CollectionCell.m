//
//  CollectionCell.m
//  ShareCollection
//
//  Created by lanouhn on 15-9-6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "CollectionCell.h"

#define kMarginLeft 10
#define kMarginTop 10
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kHeight 50
#define kInterSpacing 20

@implementation CollectionCell

- (void)dealloc {
    [_firstLabel release];
    [_secondLabel release];
    [_button release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.firstLabel];
        [self.contentView addSubview:self.secondLabel];
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (UILabel *)firstLabel {
    if (!_firstLabel) {
        CGRect frame = CGRectMake(kMarginLeft, kMarginTop, kScreenWidth / 3, kHeight);
        self.firstLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    }
    return [[_firstLabel retain] autorelease];
}

- (UILabel *)secondLabel {
    if (!_secondLabel) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), kMarginTop, kScreenWidth / 3, kHeight);
        self.secondLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    }
    return [[_secondLabel retain] autorelease];
}

- (UIButton *)button {
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(CGRectGetMaxX(self.secondLabel.frame) + kInterSpacing, kMarginTop, kScreenWidth / 3 - kMarginLeft * 2 - kInterSpacing, kHeight);
        [_button setTitle:@"收藏" forState:UIControlStateNormal];
    }
    return [[_button retain] autorelease];
}


@end









