//
//  PQTFactViewController.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/30/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PQTFactViewController.h"
#import "PQTItem.h"
#import "PQTItemStore.h"

@interface PQTFactViewController ()

@property (nonatomic, strong) PQTItem *item;

@property (weak, nonatomic) IBOutlet UILabel *factLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@end

@implementation PQTFactViewController

- (instancetype)initWithItem:(PQTItem *)item
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        self.navigationItem.title = @"Fact";
        self.navigationItem.hidesBackButton = YES;
        
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
    
    if (!self.item && [[[PQTItemStore sharedStore] allItems] count] > 0) {
        self.item = [[PQTItemStore sharedStore] nextItem];
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
    
    PQTItem *nextItem = self.item;
    
    if ([[[PQTItemStore sharedStore] allItems] count] > 1) {
        while ([nextItem isEqual:self.item]) {
            nextItem = [[PQTItemStore sharedStore] nextItem];
        }
    }
    
    PQTFactViewController *vc = [[PQTFactViewController alloc] initWithItem:nextItem];
    [self.navigationController setViewControllers:@[vc] animated:YES];
}

@end
