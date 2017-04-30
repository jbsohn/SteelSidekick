//
//  ChordViewController.m
//  SteelSidekick
//
//  Created by John on 11/1/13.
//
//

#import "ChordViewController.h"
#import "ChordTypeViewController.h"
#import "RootNoteViewController.h"
#import "SGuitar.h"
#import "ColorScheme.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

@interface ChordViewController ()  <ChordTypeViewControllerDelegate,
                                    RootNoteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *chordTypeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *rootNoteCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *showChordItemsCell;
@property (strong, nonatomic) UISwitch *showChordSwitch;

@end

@implementation ChordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDone];
    
    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];

    if (self.inPopover) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGChordOptions *chordOptions = [sguitar getChordOptions];
    
    self.showChordSwitch = [[UISwitch alloc] init];
    CGSize switchSize = [self.showChordSwitch sizeThatFits:CGSizeZero];
    self.showChordSwitch.frame = CGRectMake(self.showChordItemsCell.contentView.bounds.size.width - switchSize.width - 11.0f,
                                            (self.showChordItemsCell.contentView.bounds.size.height - switchSize.height) / 2.0f,
                                            switchSize.width,
                                            switchSize.height);
    self.showChordSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.showChordSwitch addTarget:self action:@selector(showChordSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.showChordItemsCell.contentView addSubview:self.showChordSwitch];
    self.showChordSwitch.on = chordOptions.showChord;
    
    [self resetChordName];
    [self resetChordRootNote];
    [[ColorScheme sharedInstance] applyThemeToTableView:self.tableView];
}

- (void)setupDone {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [[ColorScheme sharedInstance] applyThemeToTableViewCell:cell];
    return cell;
}

- (void)resetChordName {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGChordOptions *chordOptions = [sguitar getChordOptions];
    self.chordTypeCell.detailTextLabel.text = chordOptions.chordName;
}

- (void)resetChordRootNote {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGChordOptions *chordOptions = [sguitar getChordOptions];
    NSString *labelText = [SGuitar getNoteNameSharpFlat:chordOptions.chordRootNoteValue];
    self.rootNoteCell.detailTextLabel.text = labelText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self.delegate chordViewControllerDidFinish:self];
}

- (void)chordTypeViewControllerItemSelected:(ChordTypeViewController *)controller {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGChordOptions *chordOptions = [sguitar getChordOptions];
    chordOptions.chordName = controller.selectedChordName;
    [sguitar setChordOptions:chordOptions];

    [self resetChordName];
    [self.delegate chordViewControllerResetDisplay];
}

- (void)chordTypeViewControllerDidFinish:(ChordTypeViewController *)controller
{

}

- (void)rootNoteViewControllerItemSelected:(RootNoteViewController *)controller {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGChordOptions *chordOptions = [sguitar getChordOptions];
    chordOptions.chordRootNoteValue = controller.selectedNote;
    [sguitar setChordOptions:chordOptions];

    [self resetChordRootNote];
    [self.delegate chordViewControllerResetDisplay];
}

- (void)rootNoteViewControllerDidFinish:(RootNoteViewController *)controller {

}

- (void)chordViewControllerResetDisplay {
    [self.delegate chordViewControllerResetDisplay];
}

- (void)showChordSwitchChanged:(id)sender {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGChordOptions *chordOptions = [sguitar getChordOptions];
    chordOptions.showChord = self.showChordSwitch.on;
    [sguitar setChordOptions:chordOptions];

    [self.tableView reloadData];
    [self.delegate chordViewControllerResetDisplay];
}

const NSInteger SECTIONS_CHORD_SWITCH_ON = 2;
const NSInteger SECTIONS_CHORD_SWITCH_OFF = 1;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[self showChordSwitch] isOn]) {
        return SECTIONS_CHORD_SWITCH_ON;
    }
    return SECTIONS_CHORD_SWITCH_OFF;
}

- (void)doneSelected:(id)sender {
    [self.delegate chordViewControllerDidFinish:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGChordOptions *chordOptions = [sguitar getChordOptions];

    if ([segue.identifier isEqualToString:@"displayChordType"]) {
        ChordTypeViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.chordNames = [sguitar getChordNames];
        vc.selectedChordName = chordOptions.chordName;
    } else if ([segue.identifier isEqualToString:@"displayRootNote"]) {
        RootNoteViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.selectedNote = chordOptions.chordRootNoteValue;
    }
}

@end
