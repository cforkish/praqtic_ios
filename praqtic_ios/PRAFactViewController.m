//
//  PRAFactViewController.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/30/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PRAFactViewController.h"
#import "PRAItem.h"
#import "PRAItemStore.h"

@interface PRAFactViewController ()

@property (nonatomic, strong) PRAItem *item;

@property (weak, nonatomic) IBOutlet UILabel *factLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@end

@implementation PRAFactViewController

- (instancetype)initWithItem:(PRAItem *)item
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        self.navigationItem.title = @"Fact";
        
        _item = item;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.item && [[[PRAItemStore sharedStore] allItems] count] > 0) {
        self.item = [[PRAItemStore sharedStore] nextItem];
    }
    
    self.factLabel.text = self.item ? self.item.fact : @"Create some items!";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    
    // if we don't have an item, redirect to ItemsViewController
    if (!self.item) {
        [self.tabBarController setSelectedIndex:1];
        return;
    }
    
    PRAItem *nextItem = self.item;
    
    if ([[[PRAItemStore sharedStore] allItems] count] > 1) {
        while ([nextItem isEqual:self.item]) {
            nextItem = [[PRAItemStore sharedStore] nextItem];
        }
    }
    
    PRAFactViewController *vc = [[PRAFactViewController alloc] initWithItem:nextItem];
    [self.navigationController setViewControllers:@[vc] animated:YES];
}

@end
