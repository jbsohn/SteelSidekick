//
//  InfoViewController.m
//  SteelSidekick
//
//  Created by John Sohn on 4/11/16.
//
//

#import "PureLayout.h"
#import "UIViewController+Orientation.h"
#import "InfoViewController.h"
#import "SGuitar.h"
#import "Globals.h"

@interface InfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *scaleView;
@property (weak, nonatomic) IBOutlet UIView *chordView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *scaleImages;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *chordImages;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chordLabel;
@property NSArray *oneLineConstraints;
@property NSArray *twoLineConstraints;
@property NSArray *noteImages;
@property NSArray *noteImagesSharp;
@property NSArray *noteImagesFlat;

@end

#define NOTE_BACKGROUND                 @"Note-Background"
#define NOTE_CHORD_BACKGROUND           @"Note-ChordBackground"
#define NOTE_SCALE_BACKGROUND           @"Note-ScaleBackground"
#define NOTE_SCALE_CHORD_BACKGROUND     @"Note-ScaleChordBackground"

#define SCALE_COLOR                     0xA01401
#define CHORD_COLOR                     0x0536FF
#define SCALE_CHORD_COLOR               0x751F92

//#define CHORD_SCALE_OFFSET              22.0

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNoteImages];
    [self setupContraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupLabels];
    [self setupNoteDisplayImages:self.scaleImages isScale:YES];
    [self setupNoteDisplayImages:self.chordImages isScale:NO];
    
    ORIENTATION orientation = [self getOrientationForView:self.parentViewController.view];
    [self updateConstraintsForOrientation:orientation];
    [self.view setNeedsLayout];
}

- (void)setupContraints {
    [self createOneLineConstraints];
    [self createTwoLineConstraints];
}

- (void)setupLabels {
    SGuitar *sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];
    SGChordOptions *chordOptions = [sguitar getChordOptions];
    NSString *scaleName = @"";

    if (scaleOptions.showScale) {
        scaleName = scaleOptions.scaleName;
    }
    NSString *scaleLabel = [NSString stringWithFormat:@"Scale: %@", scaleName];
    
    NSString *chordName = @"";
    if (chordOptions.showChord) {
        chordName = chordOptions.chordName;
    }

    NSString *chordLabel = [NSString stringWithFormat:@"Chord: %@", chordName];
    
    self.scaleLabel.text = scaleLabel;
    self.chordLabel.text = chordLabel;
}

- (void)setupNoteImages {
    self.noteImages = @[@"Images/Note-C",
                        @"Images/Note-C-Sharp",
                        @"Images/Note-D-Flat",
                        @"Images/Note-D",
                        @"Images/Note-D-Sharp",
                        @"Images/Note-E-Flat",
                        @"Images/Note-E",
                        @"Images/Note-F",
                        @"Images/Note-F-Sharp",
                        @"Images/Note-G-Flat",
                        @"Images/Note-G",
                        @"Images/Note-G-Sharp",
                        @"Images/Note-A-Flat",
                        @"Images/Note-A",
                        @"Images/Note-A-Sharp",
                        @"Images/Note-B-Flat",
                        @"Images/Note-B"];
    
    self.noteImagesSharp = @[@"Images/Note-C",
                             @"Images/Note-C-Sharp",
                             @"Images/Note-D",
                             @"Images/Note-D-Sharp",
                             @"Images/Note-E",
                             @"Images/Note-F",
                             @"Images/Note-F-Sharp",
                             @"Images/Note-G",
                             @"Images/Note-G-Sharp",
                             @"Images/Note-A",
                             @"Images/Note-A-Sharp",
                             @"Images/Note-B"];
    
    self.noteImagesFlat = @[@"Images/Note-C",
                            @"Images/Note-D-Flat",
                            @"Images/Note-D",
                            @"Images/Note-E-Flat",
                            @"Images/Note-E",
                            @"Images/Note-F",
                            @"Images/Note-G-Flat",
                            @"Images/Note-G",
                            @"Images/Note-A-Flat",
                            @"Images/Note-A",
                            @"Images/Note-B-Flat",
                            @"Images/Note-B"];
}

- (void)updateDisplay {
    [self setupLabels];
    
    [self setupNoteDisplayImages:self.scaleImages isScale:YES];
    [self setupNoteDisplayImages:self.chordImages isScale:NO];
}

- (void)setupNoteDisplayImages:(NSArray *)images isScale:(BOOL)isScale {
    SGuitar* sguitar = [SGuitar sharedInstance];
    SGScaleOptions *scaleOptions = [sguitar getScaleOptions];
    SGChordOptions *chordOptions = [sguitar getChordOptions];
    NSArray *noteValues = @[];
    
    if (isScale) {  // Scale
        if (scaleOptions.showScale) {
            noteValues = [sguitar getScaleNoteValues];
        }
    } else {        // Chord
        if (chordOptions.showChord) {
            noteValues = [sguitar getChordNoteValues];
        }
    }

    for (int i = 0; i < images.count; i++) {
        UIImageView *image = images[i];
        
        if (i < noteValues.count) {
            NSNumber *note = noteValues[i];
            int noteValue = (int) [note intValue];
            image.hidden = NO;
        
            NSString *imageName;
            
            if ([sguitar getGuitarOptions].showNotesAs == ADT_SHARP) {
                imageName = [self.noteImagesSharp objectAtIndex:noteValue];
            } else {
                imageName = [self.noteImagesFlat objectAtIndex:noteValue];
            }

            image.image = [UIImage imageNamed:imageName];
            BOOL isBoth = NO;
            
            if ([sguitar getScaleOptions].showScale && [sguitar getChordOptions].showChord) {
                if (isScale) {
//                    isBoth = [[sguitar getChord] isNoteValueInChord:noteValue];
                } else {
//                    isBoth = [[sguitar getScale] isNoteValueInScale:noteValue];
                }
            }
            
            if (isBoth) {   // must check for both first
                image.backgroundColor = UIColorFromRGB(SCALE_CHORD_COLOR);
            } else if (isScale) {
                image.backgroundColor = UIColorFromRGB(SCALE_COLOR);
            } else {
                image.backgroundColor = UIColorFromRGB(CHORD_COLOR);
            }
        } else {
            image.hidden = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// get the safe layout area for iPhone X/iOS 11
- (float)offsetForInfoView {
    float offset = 0.0f;
    if (@available(iOS 11.0, *)) {
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        CGRect safeRect = [controller.view.safeAreaLayoutGuide layoutFrame];
        offset = safeRect.origin.x;
        
        // make sure we are not in portrait mode
        if (offset == 0.0f) {
            offset = safeRect.origin.y;
        }
    }
    return offset;
}

// in landscape use one line for the scale/chord view
- (void)createOneLineConstraints {
    float offset = [self offsetForInfoView];
    self.oneLineConstraints = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        [self.scaleView autoSetDimension:ALDimensionWidth toSize:240.0f];
        [self.scaleView autoSetDimension:ALDimensionHeight toSize:INFO_VIEW_SCALE_HEIGHT];
        [self.scaleView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
        [self.scaleView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:offset];
        
        [self.chordView autoSetDimension:ALDimensionWidth toSize:240.0f];
        [self.chordView autoSetDimension:ALDimensionHeight toSize:INFO_VIEW_CHORD_HEIGHT];
        [self.chordView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
        [self.chordView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-offset];
    }];
}

// in portrait use two lines, one for scale and one for chord info
- (void)createTwoLineConstraints {
    float offset = [self offsetForInfoView];
    self.twoLineConstraints = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        [self.scaleView autoSetDimension:ALDimensionHeight toSize:INFO_VIEW_SCALE_HEIGHT];
        [self.scaleView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
        [self.scaleView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:offset];
        [self.scaleView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];

        [self.chordView autoSetDimension:ALDimensionHeight toSize:INFO_VIEW_CHORD_HEIGHT];
        [self.chordView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scaleView];
        [self.chordView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:offset];
        [self.chordView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    }];
}

// update constraints for the current orientation, one line or two lines for displaying chord and scale information
- (void)updateConstraintsForOrientation:(ORIENTATION)orientation {
    BOOL useOneLine = NO;

    if (orientation == O_LANDSCAPE) {
        useOneLine = YES;
    } else if (orientation == O_PORTRAIT) {
        CGSize size = [self sizeForPortrait:self.parentViewController.view.frame.size];
        if (size.width >= INFO_VIEW_SCALE_CHORD_WIDTH) {
            useOneLine = YES;
        }
    }

    if (useOneLine) {
        [self.twoLineConstraints autoRemoveConstraints];
        [self.oneLineConstraints autoInstallConstraints];
    } else {
        [self.oneLineConstraints autoRemoveConstraints];
        [self.twoLineConstraints autoInstallConstraints];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        ORIENTATION orientation = [self getOrientationForSize:size];
        [self updateConstraintsForOrientation:orientation];
        [self.view setNeedsLayout];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self updateDisplay];
    }];
}

@end
