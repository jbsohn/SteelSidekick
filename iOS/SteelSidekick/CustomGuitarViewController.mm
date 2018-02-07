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
#import "ActionSheetPicker.h"
#import "SGuitar.h"
#import "ColorScheme.h"
#import "SCustomGuitar.hpp"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)


#define LAP_STEEL_NUMBER_OF_SECTIONS      4

#define NOTE_AND_OCTAVE_PICKER_TITLE    @"Select Note and Octave"
#define GUITAR_EXISTS_ALERT_TITLE       @"Custom Guitar Already Exists"
#define GUITAR_EXISTS_ALERT             @"The custom guitar you are saving already exists. Do you want to overwrite the existing item?"

typedef enum {
    GEAR_CANCEL,
    GEAR_OVERWRITE
} GUITAR_EXISTS_ALERT_RESPONSE_TYPE;

typedef enum {
    CGIT_GUITAR_NAME,
    CGIT_GUITAR_TYPE,
    CGIT_GUITAR_STRING_TYPE,
    CGIT_GUITAR_STRING,
    CGIT_PEDAL,
    CGIT_LEVER,
} CUSTOM_GUITAR_ITEM_TYPE;

NSString *CUSTOM_GUITAR_ITEM_TYPE_NAMES[] = {
    @"guitarNameCell",
    @"guitarTypeCell",
    @"guitarStringTypeCell",
    @"stringCell",
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
@interface CustomGuitarItem : NSObject <UIAlertViewDelegate>

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
@interface CustomGuitarViewController () <ActionSheetCustomPickerDelegate> {
    NSArray *noteValues;
    NSArray *pitchValues;
}

@property NSMutableArray *items;
@property NSString *selectedAdjustmentID;
@property BOOL editingGuitar;

// for editing string
@property int editingStringNumber;
@property int selectedNote;
@property int selectedPitch;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation CustomGuitarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set default settings for editing string
    self.selectedNote = 0;
    self.selectedPitch = 4;
    self.editingStringNumber = 1;
    
    // note/pitch values to display
    noteValues = @[@"C",
              @"C\u266f/D\u266d",
              @"D",
              @"D\u266f/E\u266d",
              @"E",
              @"F",
              @"F\u266f/G\u266d",
              @"G",
              @"G\u266f/A\u266d",
              @"A",
              @"A\u266f/B\u266d",
              @"B"];
    pitchValues = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"];

    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];
    
    [self setupItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ColorScheme sharedInstance] applyThemeToTableView:self.tableView];
    [self.tableView reloadData];
}

- (void)reset {
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();
    customGuitar.reset();
    self.editingGuitar = NO;
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
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();

    if (indexPath.section == CGS_STRINGS) {
        self.editingStringNumber = (int) (indexPath.row + 1);
        int midiValue = customGuitar.getStartNoteMIDIValue(self.editingStringNumber);
        SG::Note note(midiValue);
        self.selectedNote = note.getNoteValue();
        self.selectedPitch = note.getPitchValue();
        NSArray *initialSelections = @[[NSNumber numberWithInt:self.selectedNote],
                                       [NSNumber numberWithInt:self.selectedPitch - 1]];
        [ActionSheetCustomPicker showPickerWithTitle:NOTE_AND_OCTAVE_PICKER_TITLE
                                            delegate:self
                                    showCancelButton:NO
                                              origin:self.view
                                   initialSelections:initialSelections];
    } else if (indexPath.section == CGS_GUITAR_TYPE) {
        GUITAR_TYPE guitarType = (GUITAR_TYPE) indexPath.row;
        if (customGuitar.getGuitarType() != guitarType) {
            // user selected a new guitar type, set it and reload the table to reflect new guitar type
            customGuitar.setGuitarType(guitarType);
            [self.tableView reloadData];
        }
    } else if (indexPath.section == CGS_GUITAR_STRING_TYPE) {
        // user set the number of strings
        customGuitar.setGuitarStringType((GUITAR_STRING_TYPE) indexPath.row);
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
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();
    
    // non-pedal steel does not have pedals or levers to adjust
    if (customGuitar.getGuitarType() == GT_LAP_STEEL) {
        return LAP_STEEL_NUMBER_OF_SECTIONS;
    }
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();
    NSArray *items = self.items[section];
    NSInteger rows = 0;

    if (items) {
        if (section == CGS_STRINGS) {
            // the number of strings should reflect the current instrument being edited
            GUITAR_STRING_TYPE type = customGuitar.getGuitarStringType();
            rows = SG::Guitar::numberOfStringsForType(type);
        } else {
            rows = [items count];
        }
    }
    return rows;
}

- (IBAction)nameEditingChanged:(UITextField *)sender {
    // user changed the value in the guitar name
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();
    customGuitar.setGuitarName([sender.text UTF8String]);
    
    if (sender.text.length > 0) {
        self.saveButton.enabled = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = self.items[indexPath.section];
    CustomGuitarItem *item = items[indexPath.row];
    NSString *idName = CUSTOM_GUITAR_ITEM_TYPE_NAMES[item.type];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idName forIndexPath:indexPath];
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();

    [[ColorScheme sharedInstance] applyThemeToTableViewCell:cell];

    if (indexPath.section == CGIT_GUITAR_NAME) {
        GuitarNameTableViewCell *guitarNameCell = (GuitarNameTableViewCell *)cell;
        NSString *name = @(customGuitar.getGuitarName().c_str());
        guitarNameCell.guitarNameTextField.text = name;
        
        if (self.editingGuitar) {
            guitarNameCell.guitarNameTextField.enabled = NO;
        }
    } else if (indexPath.section == CGS_GUITAR_TYPE) {
        GUITAR_TYPE guitarType = customGuitar.getGuitarType();
        
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
        if (customGuitar.getGuitarStringType() == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == CGS_STRINGS) {
        int stringNumber = item.itemID;
        // display the guitar string note/pitch
        int midiValue = customGuitar.getStartNoteMIDIValue(stringNumber);
        SG::Note note(midiValue);
        cell.textLabel.text = [NSString stringWithFormat:@"%d", stringNumber];
        NSString *name = @(SG::NoteName::getNoteNameSharpFlat(note.getNoteValue()).c_str());
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %d", name, note.getPitchValue()];
    } else if (indexPath.section == CGS_PEDALS) {
        NSString *pedalName = @(SG::GuitarAdjustmentType::getPedalTypeName((int) indexPath.row).c_str());
        cell.textLabel.text = pedalName;

        // let user know pedal has an adjustment
        if (customGuitar.hasGuitarAdjustment([pedalName UTF8String])) {
            cell.detailTextLabel.text = @"Active";
        } else {
            cell.detailTextLabel.text = @"";
        }
    } else if (indexPath.section == CGS_LEVERS) {
        NSString *leverName = @(SG::GuitarAdjustmentType::getLeverTypeName((int) indexPath.row).c_str());
        cell.textLabel.text = leverName;

        // let user know lever has an adjustment
        if (customGuitar.hasGuitarAdjustment([leverName UTF8String])) {
            cell.detailTextLabel.text = @"Active";
        } else {
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showStringAdjustment"]) {
        // set the current adjustement ID being edited
        GuitarAdjustmentViewController *vc = segue.destinationViewController;
        vc.adjustmentID = self.selectedAdjustmentID;
    }
}

- (IBAction)cancelSelected:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveSelected:(id)sender {
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();
    BOOL save = NO;
    
    if (self.editingGuitar) {
        // editing an existing guitar, overwrite it
        save = YES;
    } else if (customGuitar.isExistingGuitar()) {
        // the guitar the user is attempting to save already exists
        // ask the user to cancel save or overwrite
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GUITAR_EXISTS_ALERT_TITLE
                                                        message:GUITAR_EXISTS_ALERT
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Overwrite", nil];
        [alert show];
    } else {
        save = YES;
    }
    
    if (save) {
        // save guitar and dismiss controller
        customGuitar.save();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();

    // the custom guitar exists but the user wants to overrrite it
    if (buttonIndex == GEAR_OVERWRITE) {
        customGuitar.save();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadGuitar:(NSString *)guitarName {
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();
    customGuitar.reset();
    customGuitar.setGuitarName([guitarName UTF8String]);
    customGuitar.load();
    self.editingGuitar = YES;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin {
    SG::SCustomGuitar& customGuitar = SG::SCustomGuitar::sharedInstance();
    SG::Note note = SG::Note(self.selectedNote, self.selectedPitch);
    
    customGuitar.setStartNoteMIDIValue(note.getMIDIValue(), self.editingStringNumber);
    [self.tableView reloadData];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [noteValues count];
    } else if (component == 1) {
        return [pitchValues count];
    }
    return 0;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 80.0f;
    } else if (component == 1) {
        return 40.0f;
    }
    return 0.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return noteValues[(NSUInteger) row];
    } else if (component == 1) {
        return pitchValues[(NSUInteger) row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedNote = (int) row;
    } else if (component == 1) {
        self.selectedPitch = (int) row + 1;
    }
}

@end
