//
//  CustomCopdentViewController.m
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import "CustomGuitarViewController.h"
#import "GuitarAdjustmentViewController.h"
#import "GuitarNameTableViewCell.h"
#import "StringNoteTableViewCell.h"
#import "CustomGuitar.h"
#import "SGuitar.h"
#import "ColorScheme.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

#define LAP_STEEL_NUMBER_OF_SECTIONS      4

typedef enum {
    CGIT_GUITAR_NAME,
    CGIT_GUITAR_TYPE,
    CGIT_GUITAR_STRING_TYPE,
    CGIT_GUITAR_STRING,
    CGIT_GUITAR_STRING_NOTE_SELECT,
    CGIT_PEDAL,
    CGIT_LEVER,
} CUSTOM_GUITAR_ITEM_TYPE;

NSString *CUSTOM_GUITAR_ITEM_TYPE_NAMES[] = {
    @"guitarNameCell",
    @"guitarTypeCell",
    @"guitarStringTypeCell",
    @"stringCell",
    @"stringNoteCell",
    @"pedalCell",
    @"leverCell"
};

typedef enum {
    CGS_NAME,
    CGS_GUITAR_TYPE,
    CGS_GUITAR_STRING_TYPE,
    CGS_STRINGS,
    CGS_PEDALS,
    CGS_LEVERS
} CUSTOM_GUITAR_SECTIONS;

NSString *CUSTOM_GUITAR_SECTIONS_NAMES[] = {
    @"Name",
    @"Guitar Type",
    @"Number of Strings",
    @"Strings",
    @"Pedals",
    @"Levers"
};

//////////////////////////////////////////////////////////////////////////////
@interface CustomGuitarItem : NSObject

@property CUSTOM_GUITAR_ITEM_TYPE type;
@property int itemID;

@end

@implementation CustomGuitarItem

- (id)initWithType:(CUSTOM_GUITAR_ITEM_TYPE)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (id)initWithType:(CUSTOM_GUITAR_ITEM_TYPE)type itemID:(int)itemID {
    self = [self initWithType:type];
    if (self) {
        self.itemID = itemID;
    }
    return self;
}

@end

////////////////////////////////////////////////////////////////////////////////
@interface CustomGuitarViewController () <StringNoteTableViewCellDelegate>

@property NSMutableArray *items;
@property NSString *selectedAdjustmentID;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation CustomGuitarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];
    
    [self setupItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ColorScheme sharedInstance] applyThemeToTableView:self.tableView];
}

- (void)reset {
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    [customGuitar reset];
    
    self.saveButton.enabled = NO;
}

- (void)setupItems {
    NSMutableArray *nameItems = [[NSMutableArray alloc] initWithArray:@[[[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_NAME]]];
    
    NSMutableArray *guitarTypeItems = [[NSMutableArray alloc] initWithArray:@[[[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_TYPE],
                                                                              [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_TYPE]]];
    
    NSMutableArray *guitarStringTypeItems = [[NSMutableArray alloc] initWithArray:@[[[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING_TYPE],
                                                                                    [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING_TYPE],
                                                                                    [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING_TYPE],
                                                                                    [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING_TYPE]]];
    
    NSMutableArray *stringItems =  [[NSMutableArray alloc] initWithArray:@[[[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:1],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:2],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:3],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:4],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:5],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:6],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:7],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:8],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:9],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:10],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:11],
                                                                           [[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING itemID:12]]];
    
    NSMutableArray *pedalItems = [[NSMutableArray alloc] initWithArray:@[[[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_PEDAL]]];
    
    NSMutableArray *leverItems = [[NSMutableArray alloc] initWithArray:@[[[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER],
                                                                         [[CustomGuitarItem alloc] initWithType:CGIT_LEVER]]];

    self.items = [[NSMutableArray alloc] initWithArray:@[nameItems, guitarTypeItems, guitarStringTypeItems, stringItems, pedalItems, leverItems]];
}

- (NSInteger)getStringNotePickerRow {
    NSArray *stringsItems = self.items[CGS_STRINGS];
    
    for (int i = 0; i < [stringsItems count]; i++) {
        CustomGuitarItem *item = stringsItems[i];
        if (item.type == CGIT_GUITAR_STRING_NOTE_SELECT) {
            return i;
        }
    }
    return -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return CUSTOM_GUITAR_SECTIONS_NAMES[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];

    if (indexPath.section == CGS_STRINGS) {
        NSInteger stringNotePickerRow = [self getStringNotePickerRow];
        if (stringNotePickerRow >= 0) {
            // string picker is active, toggle note/pitch ticker off
            NSMutableArray *stringsItems = self.items[CGS_STRINGS];
            [stringsItems removeObjectAtIndex:stringNotePickerRow];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:stringNotePickerRow inSection:CGS_STRINGS]]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } else {
            // selected a guitar string, toggle note/pitch picker on
            NSMutableArray *stringItems = self.items[CGS_STRINGS];
            [stringItems insertObject:[[CustomGuitarItem alloc] initWithType:CGIT_GUITAR_STRING_NOTE_SELECT]
                              atIndex:indexPath.row + 1];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:CGS_STRINGS]]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            StringNoteTableViewCell *noteCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:CGS_STRINGS]];
            NSArray *items = self.items[indexPath.section];
            CustomGuitarItem *item = items[indexPath.row];
            int stringNumber = item.itemID;
            noteCell.delegate = self;

            SG::Note note = [customGuitar getStartNoteForStringNumber:stringNumber];
            noteCell.note = note.getNoteValue();
            noteCell.pitch = note.getPitchValue();
            noteCell.stringNumber = stringNumber;
            [noteCell refresh];
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:CGS_STRINGS]
                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    } else if (indexPath.section == CGS_GUITAR_TYPE) {
        GUITAR_TYPE guitarType = (GUITAR_TYPE) indexPath.row;
        if (customGuitar.guitarType != guitarType) {
            // user selected a new guitar type, set it and reload the table to reflect new guitar type
            customGuitar.guitarType = guitarType;
            [self.tableView reloadData];
        }
    } else if (indexPath.section == CGS_GUITAR_STRING_TYPE) {
        // user set the number of strings
        customGuitar.guitarStringType = (GUITAR_STRING_TYPE) indexPath.row;
        [self.tableView reloadData];
    } else {
        // user selectected a pedal or lever to adjust
        NSArray *items = self.items[indexPath.section];
        CustomGuitarItem *item = items[indexPath.row];
        
        if (item.type == CGIT_PEDAL) {
            NSString *pedalName = @(SG::GuitarAdjustmentType::getPedalTypeName((int) indexPath.row).c_str());
            self.selectedAdjustmentID = pedalName;
            [self performSegueWithIdentifier:@"showStringAdjustment" sender:self];
        } else if (item.type == CGIT_LEVER) {
            NSString *leverName = @(SG::GuitarAdjustmentType::getLeverTypeName((int) indexPath.row).c_str());
            self.selectedAdjustmentID = leverName;
            [self performSegueWithIdentifier:@"showStringAdjustment" sender:self];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    
    // non-pedal steel does not have pedals or levers to adjust
    if (customGuitar.guitarType == GT_LAP_STEEL) {
        return LAP_STEEL_NUMBER_OF_SECTIONS;
    }
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    NSArray *items = self.items[section];
    NSInteger rows = 0;
    
    if (items) {
        if (section == CGS_STRINGS) {
            // the number of strings should reflect the current instrument being edited
            rows = SG::Guitar::numberOfStringsForType(customGuitar.guitarStringType);
            if ([self getStringNotePickerRow] >=0) {
                rows++;
            }
        } else {
            rows = [items count];
        }
    }
    return rows;
}

- (IBAction)nameEditingChanged:(UITextField *)sender {
    // user changed the value in the guitar name
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    [customGuitar setGuitarName:sender.text];
    
    if (sender.text.length > 0) {
        self.saveButton.enabled = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = self.items[indexPath.section];
    CustomGuitarItem *item = items[indexPath.row];
    NSString *idName = CUSTOM_GUITAR_ITEM_TYPE_NAMES[item.type];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idName forIndexPath:indexPath];
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];

    [[ColorScheme sharedInstance] applyThemeToTableViewCell:cell];

    if (indexPath.section == CGIT_GUITAR_NAME) {
        GuitarNameTableViewCell *guitarNameCell = (GuitarNameTableViewCell *)cell;
        NSString *name = customGuitar.guitarName;
        guitarNameCell.guitarNameTextField.text = name;
    } else if (indexPath.section == CGS_GUITAR_TYPE) {
        GUITAR_TYPE guitarType = customGuitar.guitarType;
        
        // set guitar type (currently pedal or lap steel)
        NSString *guitarTypeName = @(SG::Guitar::getGuitarTypeName((int) indexPath.row).c_str());
        cell.textLabel.text = guitarTypeName;

        // display checkmark if currently selected
        if (guitarType == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == CGS_GUITAR_STRING_TYPE) {
        // set number of strings type (currently 6, 8, 10 or 12)
        NSString *guitarStringTypeName = @(SG::Guitar::getGuitarStringTypeName((int) indexPath.row).c_str());
        cell.textLabel.text = guitarStringTypeName;
        
        // display checkmark if currently selected
        if (customGuitar.guitarStringType == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == CGS_STRINGS) {
        // check to see if the note/pitch picker is active
        NSInteger pickerRow = [self getStringNotePickerRow];
        int stringNumber = item.itemID;

        if (indexPath.row != pickerRow) {   // not a note/pitch picker row
            // display the guitar string note/pitch
            SG::Note note = [customGuitar getStartNoteForStringNumber:stringNumber];
            cell.textLabel.text = [NSString stringWithFormat:@"%d", stringNumber];
            NSString *name = @(SG::NoteName::getNoteNameSharpFlat(note.getNoteValue()).c_str());
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %d", name, note.getPitchValue()];
        }
    } else if (indexPath.section == CGS_PEDALS) {
        NSString *pedalName = @(SG::GuitarAdjustmentType::getPedalTypeName((int) indexPath.row).c_str());
        cell.textLabel.text = pedalName;
    } else if (indexPath.section == CGS_LEVERS) {
        NSString *leverName = @(SG::GuitarAdjustmentType::getLeverTypeName((int) indexPath.row).c_str());
        cell.textLabel.text = leverName;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *section = self.items[indexPath.section];
    CustomGuitarItem *item = section[indexPath.row];
    
    // set height to the default value defined in storyboard
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    // set the cell to a valid size for the picker view
    if (item.type == CGIT_GUITAR_STRING_NOTE_SELECT) {
        height = 220.0;
    }
    return height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showStringAdjustment"]) {
        // set the current adjustement ID being edited
        GuitarAdjustmentViewController *vc = segue.destinationViewController;
        vc.adjustmentID = self.selectedAdjustmentID;
    }
}

- (void)didSelectStringNoteItem:(StringNoteTableViewCell *)cell {
    // the user selected a note/pitch for the string from the picker view
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    int stringNumber = cell.stringNumber;
    SG::Note note = SG::Note(cell.note, cell.pitch);

    [customGuitar setNote:note forStringNumber:stringNumber];
    [self.tableView reloadData];
}

- (void)guitarAdjustmentsViewControllerDidFinish:(GuitarAdjustmentViewController *)controller {
    
}

- (void)guitarAdjustmentViewControllerItemSelected:(GuitarAdjustmentViewController *)controller {
    
}

- (IBAction)cancelSelected:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveSelected:(id)sender {
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    [customGuitar save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadGuitar:(NSString *)guitarName {
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    [customGuitar reset];
    customGuitar.guitarName = guitarName;
    [customGuitar load];
}

@end
