//
//  PQTItem.h
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface PQTItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *fact;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemUrl;


+ (instancetype)loadFromRoot:(Firebase *)root withItemId:(NSString *)itemId block:(void (^)(PQTItem*))block;

- (instancetype)initWithRoot:(Firebase *)root;
- (void)save;

- (BOOL (^)(id obj, NSUInteger idx, BOOL *stop))equalityTest;

@end
