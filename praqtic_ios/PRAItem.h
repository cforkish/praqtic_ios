//
//  PRAItem.h
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRAItem : NSObject <NSCoding>

- (instancetype)initWithFact:(NSString *)fact;

@property (nonatomic, copy) NSString *fact;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

@property (nonatomic, copy) NSString *itemKey;

@end
