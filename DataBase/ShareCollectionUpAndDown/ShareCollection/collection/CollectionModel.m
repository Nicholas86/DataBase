//
//  CollectionModel.m
//  ShareCollection
//
//  Created by lanouhn on 15-9-6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

- (void)dealloc {
    [_title release];
    [_content release];
    [super dealloc];
}

- (id)initWithID:(NSInteger)ID
               title:(NSString *)title
             content:(NSString *)content {
    self = [super init];
    if (self) {
        self.ID = ID;
        self.title = title;
        self.content = content;
    }
    return self;
}

@end
