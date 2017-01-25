//
//  GuitarAdjustmentViewController.m
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//


#import "GuitarAdjustmentViewController.h"
#import "SG/SGuitar.h"
#import "CustomGuitar.h"
#import "ColorScheme.h"

#define POPOVER_VIEW_SIZE       CGSizeMake(320.0, 480.0)
#define HEADER_HEIGHT           44.0f
#define NUMBER_OF_SECTIONS      1

//////////////////////////////////////////////////////////////////////////////
@interface StringAdjustementItem : NSObject {
    SG::StringAdjustment stringAdjustment;
}
@end

@implementation StringAdjustementItem

- (id)initWithStringAdjustment:(SG::StringAdjustment)adjustment {
    if (self = [super init]) {
        stringAdjustment = adjustment;
    }
    return self;
}

- (void)setStep:(int)step {
    stringAdjustment.setStep(step);
}

- (SG::StringAdjustment)getStringAdjustment {
    return stringAdjustment;
}

@end

////////////////////////////////////////////////////////////////////////////////
@interface GuitarAdjustmentViewController ()

@property NSArray *items;

@end

////////////////////////////////////////////////////////////////////////////////
@interface StringAdjustmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIStepper *stepsStepper;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *stringNumberLabel;
@property GuitarAdjustmentViewController* parent;

@end

@implementation StringAdjustmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateStepLabel];
}

- (void)updateStepLabel {
    self.stepLabel.text = [NSString stringWithFormat:@"%d", (int) self.stepsStepper.value];
}

- (IBAction)stepChanged:(id)sender {
    int stringNumber = (int) self.tag;
    StringAdjustementItem *item = self.parent.items[stringNumber];
    [item setStep:self.stepsStepper.value];
    [self updateStepLabel];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation GuitarAdjustmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];
    
    self.title = self.adjustmentID;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupItems];
    [[ColorScheme sharedInstance] applyThemeToTableView:self.tableView];
}

- (void)setupItems {
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    SG::GuitarAdjustment guitarAdjustment = [customGuitar getGuitarAdjustmentForAdjustmentID:self.adjustmentID];
    self.items = [[NSArray alloc] init];

    [newItems addObject:[[StringAdjustementItem alloc] init]];
    
    for (int stringNumber = 1; stringNumber <= [customGuitar getNumberOfStrings]; stringNumber++) {
        SG::StringAdjustment stringAdjustment = guitarAdjustment.stringAdjustmentForStringNumber(stringNumber);
        StringAdjustementItem *item = [[StringAdjustementItem alloc] initWithStringAdjustment:stringAdjustment];
        [newItems addObject:item];
    }
    self.items = newItems;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    SG::GuitarAdjustment newGuitarAdjustment;
    int numberOfStrings = [customGuitar getNumberOfStrings];

    for (int i = 1; i <= numberOfStrings; i++) {
        StringAdjustmentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i - 1 inSection: 0]];
        int step = cell.stepsStepper.value;
        
        if (step != 0) {
            newGuitarAdjustment.addStringAdjustment(SG::StringAdjustment(i, step));
        }
    }
    
    newGuitarAdjustment.setAdjustmentID([self.adjustmentID UTF8String]);

    [customGuitar setGuitarAdjustment:newGuitarAdjustment forAdjustmentID:self.adjustmentID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CustomGuitar *customGuitar = [CustomGuitar sharedInstance];
    int numberOfStrings = [customGuitar getNumberOfStrings];
    return numberOfStrings;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"stringAdjustmentCell";
    int stringNumber = (int) indexPath.row + 1;
    
    StringAdjustmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                          forIndexPath:indexPath];
    [[ColorScheme sharedInstance] applyThemeToTableViewCell:cell];
    
    StringAdjustementItem* item = self.items[stringNumber];
    SG::StringAdjustment stringAdjustment = [item getStringAdjustment];
    int step = stringAdjustment.getStep();

    cell.stringNumberLabel.text = [NSString stringWithFormat:@"String %d", stringNumber];
    cell.stepLabel.text = [NSString stringWithFormat:@"%d", step];
    cell.stepsStepper.value = step;
    cell.parent = self;
    cell.tag = stringNumber;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEADER_HEIGHT;
}

@end
