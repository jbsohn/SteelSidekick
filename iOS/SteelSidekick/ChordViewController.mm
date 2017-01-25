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
#import "SG/SGuitar.h"
#import "SG/NoteName.h"
#import "NSArrayStdStringVector.h"
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
    
    SG::SGuitar& guitar = SG::SGuitar::sharedInstance();
    
    self.showChordSwitch = [[UISwitch alloc] init];
    CGSize switchSize = [self.showChordSwitch sizeThatFits:CGSizeZero];
    self.showChordSwitch.frame = CGRectMake(self.showChordItemsCell.contentView.bounds.size.width - switchSize.width - 11.0f,
                                            (self.showChordItemsCell.contentView.bounds.size.height - switchSize.height) / 2.0f,
                                            switchSize.width,
                                            switchSize.height);
    self.showChordSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.showChordSwitch addTarget:self action:@selector(showChordSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.showChordItemsCell.contentView addSubview:self.showChordSwitch];
    self.showChordSwitch.on = guitar.getChordOptions().getShowChord();
    
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
    SG::SGuitar& guitar = SG::SGuitar::sharedInstance();
    self.chordTypeCell.detailTextLabel.text = @(guitar.getChordOptions().getChordName().c_str());
}

- (void)resetChordRootNote {
    SG::SGuitar& guitar = SG::SGuitar::sharedInstance();
    int chordRootNoteValue = guitar.getChordOptions().getChordRootNoteValue();
    guitar.getChordOptions().setChordRootNoteValue(chordRootNoteValue);
    NSString *labelText = @(SG::NoteName::getNoteNameSharpFlat(chordRootNoteValue).c_str());
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
    SG::SGuitar& guitar = SG::SGuitar::sharedInstance();
    guitar.getChordOptions().setChordName([controller.selectedChordName UTF8String]);
    [self resetChordName];
    [self.delegate chordViewControllerResetDisplay];
}

- (void)chordTypeViewControllerDidFinish:(ChordTypeViewController *)controller
{

}

- (void)rootNoteViewControllerItemSelected:(RootNoteViewController *)controller {
    SG::SGuitar& guitar = SG::SGuitar::sharedInstance();
    guitar.getChordOptions().setChordRootNoteValue(controller.selectedNote);
    [self resetChordRootNote];
    [self.delegate chordViewControllerResetDisplay];
}

- (void)rootNoteViewControllerDidFinish:(RootNoteViewController *)controller {

}

- (void)chordViewControllerResetDisplay {
    [self.delegate chordViewControllerResetDisplay];
}

- (void)showChordSwitchChanged:(id)sender {
    SG::SGuitar& guitar = SG::SGuitar::sharedInstance();
    guitar.getChordOptions().setShowChord(self.showChordSwitch.on);
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
    SG::SGuitar& guitar = SG::SGuitar::sharedInstance();
    if ([segue.identifier isEqualToString:@"displayChordType"]) {
        ChordTypeViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.chordNames = [NSArrayStdStringVector arrayFromStdStringVector:guitar.getChordNames()];
        vc.selectedChordName = @(guitar.getChordOptions().getChordName().c_str());
    } else if ([segue.identifier isEqualToString:@"displayRootNote"]) {
        RootNoteViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        int noteValue = guitar.getChordOptions().getChordRootNoteValue();
        vc.selectedNote = noteValue;
    }
}

@end
