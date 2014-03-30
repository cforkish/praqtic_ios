//
//  NSArray+PRAAdditions.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/30/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "NSArray+PRAAdditions.h"

@implementation NSArray (PRAAdditions)

-(id)randomObject {
    u_int32_t myCount = (u_int32_t)[self count];
    if (myCount)
        return [self objectAtIndex:arc4random_uniform(myCount)];
    else
        return nil;
}

@end
