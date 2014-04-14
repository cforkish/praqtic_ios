//
//  PQTFactViewController.m
//  praqtic_ios
//
//  Created by Charles Forkish on 4/13/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PQTFactViewController.h"

@interface PQTFactViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@end

@implementation PQTFactViewController

- (instancetype)initWithItem:(PQTItem *)item
{
    self = [super initWithItem:item];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        self.navigationItem.title = item.question ? @"Flashcard Answer" : @"Fact";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textLabel.text = self.item ? self.item.fact : @"Create some items!";
    [self.textLabel sizeToFit];
    
    NSMutableArray *buttons = [NSMutableArray array];
    
    if (self.item.question) {
        UIBarButtonItem *flipBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Flip back" style:UIBarButtonItemStyleBordered target:self action:@selector(flipBackButtonPressed:)];
        
        [buttons addObject:flipBackButton];
    }
    
    [buttons addObject:self.continueButton];
    
    [self addToolbarButtons:buttons];
}

- (void)flipBackButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

@end
