//
//  CollectionDB.h
//  ShareCollection
//
//  Created by lanouhn on 15-9-6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "CollectionModel.h"

@interface CollectionDB : NSObject
@property (nonatomic, retain) FMDatabase *db;
- (void)deleteDataFromDataBase:(NSInteger)ID;
- (void)insertDataInDataBase:(CollectionModel *)model;
- (NSMutableArray *)selectDataFromDataBase;
@end
