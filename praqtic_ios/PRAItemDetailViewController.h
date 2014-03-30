//
//  PRAItemDetailViewController.h
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRAItem;

@interface PRAItemDetailViewController : UIViewController <UIViewControllerRestoration>

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) PRAItem *item;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
