//
//  PRAItemDetailViewController.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PRAItemDetailViewController.h"
#import "PRAItem.h"
#import "PRAItemStore.h"

@interface PRAItemDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *factField;
@property (weak, nonatomic) IBOutlet UITextField *questionField;

@property (weak, nonatomic) IBOutlet UILabel *factLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@end

@implementation PRAItemDetailViewController

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path
                                                            coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([path count] == 3) {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey
                 forKey:@"item.itemKey"];
    
    // Save changes into item
    self.item.fact = self.factField.text;
    self.item.question = self.questionField.text;
    
    // Have store save changes to disk
    [[PRAItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey =
    [coder decodeObjectForKey:@"item.itemKey"];
    
    for (PRAItem *item in [[PRAItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    
    [super decodeRestorableStateWithCoder:coder];
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
            self.navigationItem.title = @"New Item";
        }
        else {
            self.navigationItem.title = @"Item Detail";
        }
        
        // Make sure this is NOT in the if (isNew ) { } block of code
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateFonts)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
    }
    
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}


- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.factLabel.font = font;
    self.questionLabel.font = font;
    
    self.factField.font = font;
    self.questionField.font = font;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PRAItem *item = self.item;
    
    self.factField.text = item.fact;
    self.questionField.text = item.question;
    
    [self updateFonts];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    PRAItem *item = self.item;
    item.fact = self.factField.text;
    item.question = self.questionField.text;
}

- (void)setItem:(PRAItem *)item
{
    _item = item;
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the PRAItem from the store
    [[PRAItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}


@end
