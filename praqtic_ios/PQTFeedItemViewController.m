//
//  PQTFactViewController.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/30/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PQTFeedItemViewController.h"
#import "PQTFactViewController.h"
#include "PQTQuestionViewController.h"

@interface PQTFeedItemViewController ()
@end

@implementation PQTFeedItemViewController

+ (instancetype)initialViewControllerForItem:(PQTItem *)item
{
    if (item.question) return [[PQTQuestionViewController alloc] initWithItem:item];
    else return [[PQTFactViewController alloc] initWithItem:item];
}

- (instancetype)initWithItem:(PQTItem *)item
{
    self = [super initWithNibName:@"PQTFeedItemViewController" bundle:nil];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
//        NSLog(@"%@ restoration class: %@", self, self.restorationClass);
        
        self.navigationItem.title = @"Feed Item";
        self.navigationItem.hidesBackButton = YES;
        
        self.item = item;
    }
    
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initWithItem:"
                                 userInfo:nil];
    return nil;
}



- (void)continueButtonPressed:(id)sender {
    
    // if we don't have an item, redirect to ItemsViewController
    if (!self.item) {
        [self.tabBarController setSelectedIndex:0];
        return;
    }
    
    PQTItem *nextItem = self.item;
    
    if ([[[PQTItemStore sharedStore] allItems] count] > 1) {
        while ([nextItem isEqual:self.item]) {
            nextItem = [[PQTItemStore sharedStore] nextItem];
        }
    }
    
    if (self.presentingViewController) {
        __weak PQTItem *weakItem = nextItem;
        [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
            self.modalDismissBlock(weakItem);
        }];
    }
    else {
        PQTFeedItemViewController *vc = [PQTFeedItemViewController initialViewControllerForItem:nextItem];
        [self.navigationController setViewControllers:@[vc] animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *gotItButton = [[UIBarButtonItem alloc] initWithTitle:@"Got it!" style:UIBarButtonItemStyleBordered target:self action:@selector(continueButtonPressed:)];
    
    self.continueButton = gotItButton;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.item && [[[PQTItemStore sharedStore] allItems] count] > 0) {
        self.item = [[PQTItemStore sharedStore] nextItem];
    }
    
    id topGuide = self.topLayoutGuide;
    id bottomGuide = self.bottomLayoutGuide;
    
    [self.view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:[topGuide][_contentView][_toolbar][bottomGuide]" options:0 metrics:nil
                          views:NSDictionaryOfVariableBindings(topGuide, _contentView, _toolbar, bottomGuide)]];
}


- (void)addToolbarButtons:(NSArray *)buttons
{
    int spacerCount = (int)[buttons count] + 1;
    NSMutableArray * spacers = [NSMutableArray arrayWithCapacity:spacerCount];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    for (int i = 0; i < spacerCount; i++) {
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [spacers addObject:spacer];
        [indexes addIndex:2*i];
    }
    
    NSMutableArray *items = [buttons mutableCopy];
    [items insertObjects:spacers atIndexes:indexes];
    
    self.toolbar.items = items;
}

@end
