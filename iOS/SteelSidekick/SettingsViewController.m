//
//  ScaleViewController.m
//  SteelSidekick
//
//  Created by John on 11/5/13.
//
//

#import "SettingsViewController.h"
#import "GuitarViewController.h"
#import "ColorSchemeViewController.h"
#import "SGuitar.h"
#import "ColorScheme.h"
#import "Globals.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

typedef enum {
    SECTION_GUITAR = 0,
    SECTION_SHOW_ALL_NOTES = 1,
    SECTION_SHOW_NOTES_AS = 2,
    SECTION_SHOW_TUTORIAL = 3
} SETTINGS_SECTIONS;

@interface SettingsViewController ()  <GuitarViewControllerDelegate, ColorSchemeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *guitarCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *showAllNotesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *colorSchemeCell;
@property (strong, nonatomic) UISwitch *showAllNotesSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDone];
    [self setupAsPopover];
    [self setupShowAllNotes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetShowAllNotes];
    [self resetGuitar];
    [self resetColorScheme];
}

- (void)setupDone {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (NSString *)getColorTheme {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *results = [defaults stringForKey:@"ColorScheme"];
    NSString *name;

    if (results) {
        // ensure the palette exists
        FlatColorPalette *palette = [FlatColorPalette defaultPaletteForName:results];
        if (!palette) {
            // default to first item
            palette = [[FlatColorPalette defaultColorPalettes] objectAtIndex:0];
        }
        
        if (palette) {
            name = palette.name;
        }
    } else {
        // default to first item
        FlatColorPalette *palette = [[FlatColorPalette defaultColorPalettes] objectAtIndex:0];
        name = palette.name;
    }
    return name;
}

- (void)setupAsPopover {
    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];
    
    if (self.inPopover) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)setupShowAllNotes {
    self.showAllNotesSwitch = [[UISwitch alloc] init];
    CGSize switchSize = [self.showAllNotesSwitch sizeThatFits:CGSizeZero];
    self.showAllNotesSwitch.frame = CGRectMake(self.showAllNotesCell.contentView.bounds.size.width - switchSize.width - 11.0f,
                                               (self.showAllNotesCell.contentView.bounds.size.height - switchSize.height) / 2.0f,
                                               switchSize.width,
                                               switchSize.height);
    self.showAllNotesSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.showAllNotesSwitch addTarget:self action:@selector(showAllNotesChanged:) forControlEvents:UIControlEventValueChanged];
    [self.showAllNotesCell.contentView addSubview:self.showAllNotesSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self.delegate settingsViewControllerDidFinish:self];
}

- (void)resetGuitar {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    self.guitarCell.detailTextLabel.text = guitarOptions.guitarName;
}

- (void)resetShowAllNotes {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    self.showAllNotesSwitch.on = guitarOptions.showAllNotes;
}

- (void)resetColorScheme {
    NSString *labelText =  [self getColorTheme];
    self.colorSchemeCell.detailTextLabel.text = labelText;
    [[ColorScheme sharedInstance] applyThemeToTableView:self.tableView];
    [self.tableView reloadData];
}

- (void)guitarViewControllerItemSelected:(GuitarViewController *)controller {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    guitarOptions.guitarType = controller.selectedGuitarType;
    guitarOptions.guitarName = controller.selectedGuitarName;
    [sguitar setGuitarOptions:guitarOptions];

    [self resetGuitar];
    [self.delegate settingsViewControllerResetDisplay];
}

- (void)guitarViewControllerDidFinish:(GuitarViewController *)controller {
    [self.delegate settingsViewControllerResetDisplay];
}

- (void)didSelectNewTheme:(ColorSchemeViewController *)controller {
    [self.delegate settingsViewControllerResetDisplay];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    if ([segue.identifier isEqualToString:@"displayGuitar"]) {
        GuitarViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.selectedGuitarName = guitarOptions.guitarName;
        vc.selectedGuitarType = guitarOptions.guitarType;
    } else if ([segue.identifier isEqualToString:@"showColorScheme"]) {
        ColorSchemeViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

- (void)showAllNotesChanged:(id)sender {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    guitarOptions.showAllNotes = self.showAllNotesSwitch.on;
    [sguitar setGuitarOptions:guitarOptions];

    [self.tableView reloadData];
    [self.delegate settingsViewControllerResetDisplay];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [[ColorScheme sharedInstance] applyThemeToTableViewCell:cell];

    SGuitar *sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    
    if (indexPath.section == SECTION_SHOW_NOTES_AS) {
        if (guitarOptions.showNotesAs ==  indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == SECTION_SHOW_NOTES_AS) {
        SGuitar *sguitar = [SGuitar sharedInstance];
        SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
        
        UITableViewCell *prevCell =
                [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:guitarOptions.showNotesAs
                                                                         inSection:SECTION_SHOW_NOTES_AS]];
        prevCell.accessoryType = UITableViewCellAccessoryNone;
        
        guitarOptions.showNotesAs = (ACCIDENTAL_DISPLAY_TYPE) indexPath.row;
        [sguitar setGuitarOptions:guitarOptions];

        UITableViewCell *newCell =
                [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:guitarOptions.showNotesAs
                                                                         inSection:SECTION_SHOW_NOTES_AS]];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.delegate settingsViewControllerResetDisplay];
    } else if (indexPath.section == SECTION_SHOW_TUTORIAL) {
        [self.delegate settingsViewControllerStartTutorial:self];
    }
}

@end
