//
//  PQTQuestionVuewController.m
//  praqtic_ios
//
//  Created by Charles Forkish on 4/13/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PQTQuestionViewController.h"
#import "PQTFactViewController.h"

@implementation PQTQuestionViewController

- (instancetype)initWithItem:(PQTItem *)item
{
    self = [super initWithItem:item];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        self.navigationItem.title = @"Flashcard Question";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textLabel.text = self.item ? self.item.question : @"Create some items!";
    [self.textLabel sizeToFit];
    
    NSMutableArray *buttons = [NSMutableArray array];
    
    self.continueButton.title = @"Skip";
    [buttons addObject:self.continueButton];
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithTitle:@"Flip over" style:UIBarButtonItemStyleBordered target:self action:@selector(flipOverButtonPressed:)];
    [buttons addObject:flipButton];
    
    
    [self addToolbarButtons:buttons];
}

- (void)flipOverButtonPressed:(id)sender {
    PQTFactViewController *vc = [[PQTFactViewController alloc] initWithItem:self.item];
    
    vc.modalDismissBlock = ^(PQTItem *nextItem){
        PQTFeedItemViewController *vc = [PQTFeedItemViewController initialViewControllerForItem:nextItem];
        [self.navigationController setViewControllers:@[vc] animated:YES];
    };
    
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
