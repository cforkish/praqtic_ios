//
//  PQTFactViewController.h
//  praqtic_ios
//
//  Created by Charles Forkish on 3/30/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PQTItem.h"
#import "PQTItemStore.h"

@interface PQTFeedItemViewController : UIViewController

+ (instancetype)initialViewControllerForItem:(PQTItem *)item;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) UIBarButtonItem *continueButton;

@property (nonatomic, copy) void (^modalDismissBlock)(PQTItem *);

@property (nonatomic, strong) PQTItem *item;


- (instancetype)initWithItem:(PQTItem*)item;
- (void)continueButtonPressed:(id)sender;

- (void)addToolbarButtons:(NSArray *)buttons;

@end
