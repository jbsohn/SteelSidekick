//
//  ScaleViewController.m
//  SteelSidekick
//
//  Created by John on 11/5/13.
//
//

#import "SettingsViewController.h"
#import "GuitarViewController.h"
#import "SoundViewController.h"
#import "SGuitar.h"
#import "Globals.h"
#import "SteelSidekick-Swift.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

typedef enum {
    SECTION_GUITAR = 0,
    SECTION_SHOW_ALL_NOTES = 1,
    SECTION_SHOW_NOTES_AS = 2,
    SECTION_SOUND = 3,
    SECTION_SHOW_TUTORIAL = 4
} SETTINGS_SECTIONS;

@interface SettingsViewController ()  <GuitarViewControllerDelegate, SoundViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *guitarCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *showAllNotesCell;
@property (strong, nonatomic) UISwitch *showAllNotesSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *soundCell;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

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
    [self resetSound];
    [self resetVolume];
}

- (void)setupDone {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.navigationItem.rightBarButtonItem = nil;
    }
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

- (void)resetSound {
    NSString *selectedSoundName = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedSoundName"];
    self.soundCell.detailTextLabel.text = selectedSoundName;
}

- (void)resetVolume {
    NSNumber *velocity = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedSoundVolume"];
    if (!velocity) {
        velocity = @64;
    }
    self.volumeSlider.value = [velocity floatValue];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    if ([segue.identifier isEqualToString:@"displayGuitar"]) {
        GuitarViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.selectedGuitarName = guitarOptions.guitarName;
        vc.selectedGuitarType = guitarOptions.guitarType;
    } else if ([segue.identifier isEqualToString:@"displaySound"]) {
        NSString *selectedSoundName = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedSoundName"];

        SoundViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.soundNames = [MIDIPlayer shared].soundNames;
        vc.selectedSoundName = selectedSoundName;
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

- (void)soundViewControllerDidFinish:(SoundViewController *)controller {

}

- (void)soundViewControllerItemSelected:(SoundViewController *)controller {
    [[NSUserDefaults standardUserDefaults] setObject:controller.selectedSoundName forKey:@"selectedSoundName"];
    [[MIDIPlayer shared] loadSoundWithName:controller.selectedSoundName error:nil];
}

- (IBAction)volumeSliderChanged:(UISlider *)sender {
    [[MIDIPlayer shared] stopAllNotes];
    [[NSUserDefaults standardUserDefaults] setInteger:sender.value forKey:@"selectedSoundVolume"];
    [[MIDIPlayer shared] setVelocity:sender.value];
}

@end
