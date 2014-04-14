//
//  PQTItemStore.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PQTItemStore.h"
#import <Firebase/Firebase.h>
#import "PQTItem.h"
#import "NSArray+PQTAdditions.h"

static NSString * const FirebaseRoot =  @"https://praqtic.firebaseIO.com";


@interface PQTItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@property (strong, nonatomic) Firebase* root;
@property (strong, nonatomic) Firebase* itemsRef;

@end

@implementation PQTItemStore

+ (instancetype)sharedStore
{
    static PQTItemStore *sharedStore = nil;
    
    // Do I need to create a sharedStore?
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// If a programmer calls [[PQTItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[PQTItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        self.privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!self.privateItems) {
            self.privateItems = [[NSMutableArray alloc] init];
        }
        
        self.root = [[Firebase alloc] initWithUrl:FirebaseRoot];
        self.itemsRef = [self.root childByAppendingPath:@"items"];
        [self loadItemsFromFirebase:self.itemsRef];
    }
    return self;
}

- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (void)loadItemsFromFirebase:(Firebase*)ref
{
    __weak PQTItemStore *weakSelf = self;
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"Child added with snapshot: %@", snapshot);
        if (weakSelf) {
            NSString *itemId = snapshot.name;
            __block PQTItem *item = [PQTItem loadFromRoot:self.root withItemId:itemId block:nil];
            if ([weakSelf.privateItems indexOfObjectPassingTest:[item equalityTest]] == NSNotFound) {
                [weakSelf.privateItems addObject:item];
            }
        }
    }];

    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(snapshot.value == [NSNull null]) {
            NSLog(@"Items doesn't exist");
        } else {
//            NSString* firstName = snapshot.value[@"name"][@"first"];
//            NSString* lastName = snapshot.value[@"name"][@"last"];
//            NSLog(@"User julie's full name is: %@ %@", firstName, lastName);
//            NSLog(@"Loaded items: %@", snapshot);
        }
    }];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (PQTItem *)createItem
{
    PQTItem *item = [[PQTItem alloc] initWithRoot:self.root];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(PQTItem *)item
{
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // Get pointer to object being moved so you can re-insert it
    PQTItem *item = self.privateItems[fromIndex];
    
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}

- (PQTItem*)nextItem
{
    return [self.privateItems randomObject];
}

@end
