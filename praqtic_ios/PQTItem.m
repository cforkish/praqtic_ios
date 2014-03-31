//
//  PQTItem.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PQTItem.h"


@interface PQTItem ()

@property (nonatomic, strong) NSDate *dateCreated;



@property (nonatomic) FirebaseHandle valueHandle;
@property (nonatomic) BOOL loaded;
@property (strong, nonatomic) Firebase *ref;

@end


typedef void (^pqtbt_void_pqtitem)(PQTItem* item);

@implementation PQTItem



+ (instancetype)loadFromRoot:(Firebase *)root withItemId:(NSString *)itemId block:(pqtbt_void_pqtitem)block {
    
    pqtbt_void_pqtitem userBlock = [block copy];
    Firebase* itemRef = [[root childByAppendingPath:@"items"] childByAppendingPath:itemId];
    return [[PQTItem alloc] initWithRef:itemRef andBlock:userBlock];
}

- (id)initWithRef:(Firebase *)ref andBlock:(pqtbt_void_pqtitem)block {
    self = [super init];
    if (self) {
        self.ref = ref;
        self.itemUrl = ref.description;
        // Load the data for this spark from Firebase
        self.valueHandle = [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            id rawVal = snapshot.value;
            if (rawVal == [NSNull null]) {
                block(nil);
            } else {
                NSDictionary* val = rawVal;
                self.fact = [val objectForKey:@"fact"];
                self.question = [val objectForKey:@"question"];
                if (block) {
                    block(self);
                }
            }
        }];
    }
    return self;
}

- (void)stopObserving {
    [self.ref removeObserverWithHandle:self.valueHandle];
}

- (instancetype)initWithRoot:(Firebase *)root
{
    self = [super init];
    
    if (self) {
        self.dateCreated = [[NSDate alloc] init];
        self.ref = [[root childByAppendingPath:@"items"] childByAutoId];
        self.itemUrl = self.ref.description;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.fact = [aDecoder decodeObjectForKey:@"fact"];
        self.question = [aDecoder decodeObjectForKey:@"question"];
        self.dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        self.itemUrl = [aDecoder decodeObjectForKey:@"itemUrl"];
        self.ref = [[Firebase alloc] initWithUrl:self.itemUrl];
        
    }
    return self;
}

- (id)init {
    
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initWithRoot:"
                                 userInfo:nil];
    return nil;
}

- (void)save
{
    NSDictionary* itemDict = @{@"fact": self.fact, @"question": self.question};
    
    __weak PQTItem *weakSelf = self;
    
    [self.ref setValue:itemDict withCompletionBlock:^(NSError *error, Firebase* ref) {
        if (error) {
            NSLog(@"Error posting item: %@", weakSelf.description);
        } else  {
            NSLog(@"Posted item: %@", weakSelf.description);
        }
    }];
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"Fact: %@, Question: %@, Created: %@, URL: %@",
     self.fact,
     self.question,
     self.dateCreated,
     self.itemUrl];
    return descriptionString;
}

- (NSComparisonResult)compare:(PQTItem *)other {
    // If two items have the same id, consider them equivalent
    return [self.itemUrl compare:other.itemUrl];
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fact forKey:@"fact"];
    [aCoder encodeObject:self.question forKey:@"question"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemUrl forKey:@"itemUrl"];
}

- (BOOL (^)(id obj, NSUInteger idx, BOOL *stop))equalityTest
{
   return ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
       
       if ([obj isKindOfClass:[PQTItem class]]) {
           return [((PQTItem*)obj).itemUrl isEqualToString:self.itemUrl];
       }
       else {
           return false;
       }
   };
}

@end
