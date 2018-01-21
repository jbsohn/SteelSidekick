//
//  GuitarViewController.m
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import "GuitarViewController.h"
#import "CustomGuitarViewController.h"
#import "SGuitar.h"
//#import "NSArrayStdStringVector.h"
#import "ColorScheme.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

//////////////////////////////////////////////////////////////////////
@interface GuitarViewItem : NSObject

@property NSString *name;
@property NSString *type;
@property BOOL isButton;
@property BOOL isCustomType;
@end

@implementation GuitarViewItem

@end

//////////////////////////////////////////////////////////////////////
@interface GuitarViewController ()

@property NSArray *items;
@property NSArray *sectionTitles;
@property UIBarButtonItem *editButton;
@property UIBarButtonItem *doneButton;

@end

@implementation GuitarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAsPopover];
    [self setupItems];
    [self setupBarButtonItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ColorScheme sharedInstance] applyThemeToTableView:self.tableView];
    [self setupItems];
    
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *options = [sguitar getGuitarOptions];
    self.selectedGuitarName = options.guitarName;
    
    [self.tableView reloadData];
}

- (void)setupBarButtonItems {
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self
                                                                    action:@selector(editSelected:)];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(doneSelected:)];
    self.navigationItem.rightBarButtonItem = self.editButton;
}

- (void)setupAsPopover {
    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];
}

- (void)setupItems {
    SGuitar *sguitar = [SGuitar sharedInstance];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] init];

    // add guitars by type
    NSArray *types = [sguitar getGuitarTypeNames];
    for (NSString *curType in types) {
        NSArray *curGuitars = [sguitar getGuitarNames:curType];

        NSMutableArray *curItems = [[NSMutableArray alloc] init];
        for (NSString *curGuitar in curGuitars) {
            GuitarViewItem *item = [[GuitarViewItem alloc] init];
            item.name = curGuitar;
            item.type = curType;
            item.isButton = NO;
            [curItems addObject:item];
        }

        [items addObject:curItems];
        [sectionTitles addObject:curType];
    }

    
    NSMutableArray *curItems = [[NSMutableArray alloc] init];
    NSArray *customTypes = [sguitar getCustomGuitarNames];
    
    GuitarViewItem *item = [[GuitarViewItem alloc] init];
    item.name = @"Create New Guitar";
    item.isButton = YES;
    [curItems addObject:item];
    
    for (NSString *curGuitar in customTypes) {
        GuitarViewItem *item = [[GuitarViewItem alloc] init];
        item.name = curGuitar;
        item.type = @"Custom";
        item.isButton = NO;
        item.isCustomType = YES;
        [curItems addObject:item];
    }

    [items addObject:curItems];
    [sectionTitles addObject:@"Custom"];

    self.sectionTitles = sectionTitles;
    self.items = items;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate guitarViewControllerDidFinish:self];
}

- (int)sectionForGuitarType:(NSString *)guitarType {
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        NSString *curType = self.sectionTitles[i];
        if ([curType isEqualToString:guitarType]) {
            return i;
        }
    }
    return -1;
}

- (int)indexForGuitarName:(NSString *)guitarName forType:(NSString *)guitarType {
    int section = [self sectionForGuitarType:guitarType];
    
    if (section >= 0) {
        NSArray *sectionItems = self.items[section];
        if (sectionItems && [sectionItems count] > 0) {
            for (int i = 0; i < [sectionItems count]; i++) {
                GuitarViewItem *item = sectionItems[i];
                NSString *curName = item.name;
                if ([curName isEqualToString:guitarName]) {
                    return i;
                }
            }
        }
    }
    return -1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *name = self.sectionTitles[section];
    return name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionItems = self.items[section];
    return [sectionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"guitarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [[ColorScheme sharedInstance] applyThemeToTableViewCell:cell];

    NSArray *sectionItems = self.items[indexPath.section];
    GuitarViewItem *item = sectionItems[indexPath.row];
    NSString *name = item.name;
    cell.textLabel.text = name;

    if (item.isButton || item.isCustomType) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
    }
    
    if (item.isCustomType) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([name isEqualToString:self.selectedGuitarName]) {
        cell.imageView.image = [UIImage imageNamed:@"checkmark"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"checkmark-off"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *sectionItems = self.items[indexPath.section];
    GuitarViewItem *item = sectionItems[indexPath.row];
    [self performSegueWithIdentifier:@"showCreateEditGuitar" sender:item];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *sectionItems = self.items[indexPath.section];
    NSString *type = self.sectionTitles[indexPath.section];
    GuitarViewItem *item = sectionItems[indexPath.row];
    
    if (item.isButton) {
        [self performSegueWithIdentifier:@"showCreateEditGuitar" sender:item];
    } else {
        NSString *name = item.name;
        int oldSelectedSection = [self sectionForGuitarType:self.selectedGuitarType];
        int oldSelectedRow = [self indexForGuitarName:self.selectedGuitarName forType:self.selectedGuitarType];
        UITableViewCell *prevCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldSelectedRow
                                                                                             inSection:oldSelectedSection]];
        prevCell.imageView.image = [UIImage imageNamed:@"checkmark-off"];

        UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
        newCell.imageView.image = [UIImage imageNamed:@"checkmark"];

        self.selectedGuitarType = type;
        self.selectedGuitarName = name;

        [self.delegate guitarViewControllerItemSelected:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionItems = self.items[indexPath.section];
    GuitarViewItem *item = sectionItems[indexPath.row];

    if (item.isCustomType && ![item.name isEqualToString:self.selectedGuitarName]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SGuitar *sguitar = [SGuitar sharedInstance];
    NSArray *sectionItems = self.items[indexPath.section];
    GuitarViewItem *item = sectionItems[indexPath.row];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // ensure we are deleting a user defined type
        if (item.isCustomType) {
            if ([sguitar removeCustomGuitar:item.name]) {
                [self setupItems];
                [self.tableView reloadData];
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCreateEditGuitar"]) {
        GuitarViewItem *item = sender;
        CustomGuitarViewController *controller = segue.destinationViewController;
        
        if (item.isCustomType) {
            // editing an existig item
            [controller loadGuitar:item.name];
        } else {
            // start a new custom guitar editing session, clear out any existing values in the model
            [controller reset];
        }
    }
}

- (void)startEditing {
    self.editing = YES;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (void)endEditing {
    self.editing = NO;
    self.navigationItem.rightBarButtonItem = self.editButton;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;
}

- (void)editSelected:(id)sender {
    [self startEditing];
}

- (void)doneSelected:(id)sender {
    [self endEditing];
}

@end
