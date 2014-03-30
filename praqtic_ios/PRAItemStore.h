//
//  PRAItemStore.h
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRAItem;

@interface PRAItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;

- (PRAItem *)createItem;
- (void)removeItem:(PRAItem *)item;

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex;

- (BOOL)saveChanges;

- (PRAItem*)nextItem;

@end
