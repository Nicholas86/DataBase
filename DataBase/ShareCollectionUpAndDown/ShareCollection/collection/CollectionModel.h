//
//  CollectionModel.h
//  ShareCollection
//
//  Created by lanouhn on 15-9-6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
- (id)initWithID:(NSInteger)ID
           title:(NSString *)title
         content:(NSString *)content;
@end
