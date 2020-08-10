//
//  ScaleViewController.m
//  SteelSidekick
//
//  Created by John on 11/1/13.
//
//

#import "ScaleViewController.h"
#import "ScaleTypeViewController.h"
#import "RootNoteViewController.h"
#import "SGuitar.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

@interface ScaleViewController ()  <UITableViewDelegate,
                                    ScaleTypeViewControllerDelegate,
                                    RootNoteViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableViewCell *scaleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *rootNoteCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *showScaleItemsCell;
@property (strong, nonatomic)  UISwitch *showScaleSwitch;

@end

@implementation ScaleViewController

const NSInteger SECTIONS_SCALE_SWITCH_ON = 3;
const NSInteger SECTIONS_SCALE_SWITCH_OFF = 1;

typedef enum { SECTION_SHOW_SCALE = 0,  SECTION_SCALE = 1, SECTION_DISPLAY_AS = 2 } SCALE_SECTIONS;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDone];
    [self setupScaleSwitch];
    [self setupAsPopover];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetScaleName];
    [self resetScaleRootNote];
}

- (void)setupDone {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setupScaleSwitch {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];

    self.showScaleSwitch = [[UISwitch alloc] init];
    CGSize switchSize = [self.showScaleSwitch sizeThatFits:CGSizeZero];
    self.showScaleSwitch.frame = CGRectMake(self.showScaleItemsCell.contentView.bounds.size.width - switchSize.width - 11.0f,
                                            (self.showScaleItemsCell.contentView.bounds.size.height - switchSize.height) / 2.0f,
                                            switchSize.width,
                                            switchSize.height);
    self.showScaleSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.showScaleSwitch addTarget:self action:@selector(showScaleSwitchChanged:)
                   forControlEvents:UIControlEventValueChanged];
    [self.showScaleItemsCell.contentView addSubview:self.showScaleSwitch];
    self.showScaleSwitch.on = scaleOptions.showScale;
}

- (void)setupAsPopover {
    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];

    if (self.inPopover) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)resetScaleName {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];
    NSString *labelText = scaleOptions.scaleName;
    self.scaleCell.detailTextLabel.text = labelText;
}

- (void)resetScaleRootNote {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];
    int scaleRootNoteValue = scaleOptions.scaleRootNoteValue;
    NSString *labelText = [SGuitar getNoteNameSharpFlat:scaleRootNoteValue];
    self.rootNoteCell.detailTextLabel.text = labelText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self.delegate scaleViewControllerDidFinish:self];
}

- (void)scaleTypeViewControllerItemSelected:(ScaleTypeViewController *)controller {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];

    scaleOptions.scaleName = controller.selectedScaleName;
    [sguitar setScaleOptions:scaleOptions];

    [self resetScaleName];
    [self.delegate scaleViewControllerResetDisplay];
}

- (void)scaleTypeViewControllerDidFinish:(ScaleTypeViewController *)controller {

}

- (void)rootNoteViewControllerItemSelected:(RootNoteViewController *)controller {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];

    int rootNoteValue = (int) controller.selectedNote;
    scaleOptions.scaleRootNoteValue = rootNoteValue;
    [sguitar setScaleOptions:scaleOptions];

    [self resetScaleRootNote];
    [self.delegate scaleViewControllerResetDisplay];
}

- (void)rootNoteViewControllerDidFinish:(RootNoteViewController *)controller {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];

    if ([segue.identifier isEqualToString:@"displayScaleType"]) {
        ScaleTypeViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.selectedScaleName = scaleOptions.scaleName;
        vc.scaleNames = sguitar.getScaleNames;
    } else if ([segue.identifier isEqualToString:@"displayRootNote"]) {
        RootNoteViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        int rootNoteValue = scaleOptions.scaleRootNoteValue;
        vc.selectedNote = rootNoteValue;
    }
}

- (void)showScaleSwitchChanged:(id)sender {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];
    scaleOptions.showScale = self.showScaleSwitch.on;
    [sguitar setScaleOptions:scaleOptions];

    [self.tableView reloadData];
    [self.delegate scaleViewControllerResetDisplay];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.showScaleSwitch.on) {
        return SECTIONS_SCALE_SWITCH_ON;
    }
    return SECTIONS_SCALE_SWITCH_OFF;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == SECTION_DISPLAY_AS) {
        if (scaleOptions.displayItemsAs ==  indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == SECTION_DISPLAY_AS) {
        UITableViewCell *prevCell =
                [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:scaleOptions.displayItemsAs
                                                                         inSection:SECTION_DISPLAY_AS]];
        prevCell.accessoryType = UITableViewCellAccessoryNone;
        
        
        scaleOptions.displayItemsAs = (DISPLAY_ITEM_AS_TYPE) indexPath.row;
        [sguitar setScaleOptions:scaleOptions];

        UITableViewCell *newCell =
                [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:scaleOptions.displayItemsAs
                                                                         inSection:SECTION_DISPLAY_AS]];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;

        [self.delegate scaleViewControllerResetDisplay];
    }
}

@end
