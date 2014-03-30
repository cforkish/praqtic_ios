//
//  PRAItem.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PRAItem.h"


@interface PRAItem ()

@property (nonatomic, strong) NSDate *dateCreated;

@end

@implementation PRAItem

- (id)initWithFact:(NSString *)fact
{
    self = [super init];
    
    if (self) {
        _fact = fact;
        self.dateCreated = [[NSDate alloc] init];
        
        // Create a NSUUID object - and get its string representation
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    return self;
}

- (id)init {
    return [self initWithFact:@"New Item"];
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"Fact: %@, Question: %@, Created: %@",
     self.fact,
     self.question,
     self.dateCreated];
    return descriptionString;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _fact = [aDecoder decodeObjectForKey:@"fact"];
        _question = [aDecoder decodeObjectForKey:@"question"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fact forKey:@"fact"];
    [aCoder encodeObject:self.question forKey:@"question"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
}

@end
