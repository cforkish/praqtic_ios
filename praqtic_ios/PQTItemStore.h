//
//  PQTItemStore.h
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PQTItem;

@interface PQTItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;

- (PQTItem *)createItem;
- (void)removeItem:(PQTItem *)item;

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex;

- (BOOL)saveChanges;

- (PQTItem*)nextItem;

@end
