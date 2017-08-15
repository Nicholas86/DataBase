//
//  ChannelMenuView.h
//  ShareCollection
//
//  Created by lanouhn on 15-9-7.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelMenuViewDelegate <NSObject>
- (void)passValue:(NSString *)value;
@end

@interface ChannelMenuView : UIView
@property (nonatomic, assign) id<ChannelMenuViewDelegate> delegate;
@end
