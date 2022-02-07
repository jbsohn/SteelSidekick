//
//  ViewController.m
//  SteelSidekick
//
//  Created by John Sohn on 1/31/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "SteelSidekick-Swift.h"
#import "UIViewController+Orientation.h"
#import "ViewController.h"
#import "PureLayout.h"
#import "ScaleViewController.h"
#import "ChordViewController.h"
#import "SettingsViewController.h"
#import "SGuitar.h"
#import "BTBalloon.h"
#import "NSTimer+Blocks.h"
#import "Globals.h"

@interface ViewController ()
    <GLKViewDelegate,
    ScaleViewControllerDelegate,
    ChordViewControllerDelegate,
    SettingsViewControllerDelegate,
    UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *pedalActivatedImageViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *leverActivatedImageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scaleButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *chordButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *leftLeverView;
@property (weak, nonatomic) IBOutlet UIView *rightLeverView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pedalButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *leverButtons;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet GLKView *glView;

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) InfoViewController* infoViewController;
@property (strong, nonatomic) NSArray *landscapeConstraints;
@property (strong, nonatomic) NSArray *portraitConstraints;
@property (nonatomic, assign) float pedalLeverHeight;
@property (nonatomic, assign) BOOL runningTutorial;
@property (nonatomic, assign) BOOL isCanvasInitialized;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDevice];
    [self setupGL];
    [self setupContraints];
    [self setupSound];
    [self setupGestures];
}

- (void)setupGL {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    } else {
        [EAGLContext setCurrentContext:self.context];
        self.glView.context = self.context;
        self.glView.delegate = self;
        self.glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        self.glView.drawableStencilFormat = GLKViewDrawableStencilFormat8;
        self.glView.enableSetNeedsDisplay = YES;
    }
}

- (void)tearDownGL {
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }

    self.context = nil;
}

- (void)setupSound {
    MIDIPlayer *player = [MIDIPlayer shared];
    [player startAndReturnError:nil];

    NSString *selectedSoundName = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedSoundName"];
    if ([selectedSoundName length] <= 0) {
        selectedSoundName = @"Hawaiian Guitar";
        [[NSUserDefaults standardUserDefaults] setObject:selectedSoundName forKey:@"selectedSoundName"];
    }
    
    NSNumber *velocity = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedSoundVolume"];
    if (!velocity) {
        velocity = @64;
        [[NSUserDefaults standardUserDefaults] setValue:velocity forKey:@"selectedSoundVolume"];
    }

    player.velocity = [velocity intValue];
    [player loadSoundWithName:selectedSoundName error:nil];
}

- (void)setupGestures {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    [self.glView addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    SGuitar* sguitar = [SGuitar sharedInstance];

    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self.glView];
    
        GUITAR_CANVAS_POSITION position = [sguitar positionAtCoordinates:point.x y:point.y];
        
        if (position.stringNumber >= 0 && position.fretNumber >= 0) {
            [self playNoteForStringNumber:position.stringNumber atFret:position.fretNumber];
            
            // highlight the note
            [sguitar setSelectedItem:position];
            [self.glView setNeedsDisplay];

            // reset note selected after interval
            [NSTimer scheduledTimerWithTimeInterval:0.25 block:^{
                GUITAR_CANVAS_POSITION none;
                none.stringNumber = -1;
                none.fretNumber = -1;
                [sguitar setSelectedItem:none];
                [self.glView setNeedsDisplay];
            } repeats:NO];
        }
    }
}

// sound interface
- (void)playNoteForStringNumber:(int)stringNumber atFret:(int)fretNumber {
    SGuitar* sguitar = [SGuitar sharedInstance];
    int midiNoteValue = [sguitar midiValue:stringNumber fretNumber:fretNumber];
    
    if (midiNoteValue > 0) {
        MIDIPlayer *player = [MIDIPlayer shared];
        [player stopNote:midiNoteValue];
        [player playNote:midiNoteValue];
    }
}

- (void)setupForDevice {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.pedalLeverHeight = IPAD_PEDAL_LEVER_HEIGHT;
    } else if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
        CGFloat height = [UIScreen mainScreen].applicationFrame.size.height;
        
        CGFloat portraitHeight;
        if (width > height) {
            portraitHeight = width;
        } else {
            portraitHeight = height;
        }
        
        if (portraitHeight > 667) {
            self.pedalLeverHeight = IPHONE_XLARGE_PEDAL_LEVER_HEIGHT;
        } else if (portraitHeight > 568.0) {
            self.pedalLeverHeight = IPHONE_LARGE_PEDAL_LEVER_HEIGHT;
        } else {
            self.pedalLeverHeight = IPHONE_PEDAL_LEVER_HEIGHT;
        }
    }
}

- (void)setupCanvasForOrientation:(ORIENTATION)orientation {
    SGuitar* sguitar = [SGuitar sharedInstance];

    float borderWidth = 11.0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        borderWidth = 15.0;
    }
    
    float width = self.glView.frame.size.width;
    float height = self.glView.frame.size.height;
    float noteWidthHeight = [sguitar cacluateNoteWidthHeight:width height:height];
    float left = 0.0;

    if (@available(iOS 11.0, *)) {
        CGRect safeRect = [self.view.safeAreaLayoutGuide layoutFrame];
        left = safeRect.origin.x;
    }

    if (!self.isCanvasInitialized) {
        [sguitar initCanvas:width height:height noteWidthHeight:noteWidthHeight borderWidth:borderWidth scale:[[UIScreen mainScreen] scale] leftSafeArea:left];
        self.isCanvasInitialized = YES;
    } else {
        [sguitar updateCanvasDimensions:width height:height noteWidthHeight:noteWidthHeight scale:[UIScreen mainScreen].scale leftSafeArea:left];
    }
}

- (void)setupContraints {
    // setup different constraints for landscape and portrait to keep the fretboard in the
    // same location regardless of the orientation
    [self createLandscapeConstraints];
    [self createPortraitConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.hidden = YES;

    [self resetTitle];
    [self updateAdjustments];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self resetTitle];
    
    // ensure proper constraints are active
    ORIENTATION orientation = [self getOrientation];
    [self updateConstraintsForOrientation:orientation];
    [self.view setNeedsLayout];
    
    [self startTutorial];
    self.view.hidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // rotate pedals and levers for orientation, update fretboard
    ORIENTATION orientation = [self getOrientation];
    [self rotateViewsForOrientation:orientation];
    [self setupCanvasForOrientation:orientation];
    [self.glView setNeedsDisplay];
}

- (void)startTutorial {
    // check to see if the tutorial has run
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL ranTutorial = [defaults integerForKey:RAN_TUTORIAL_KEY];


    // if not display the balloon help
    if (!ranTutorial && !self.runningTutorial) {
        self.runningTutorial = YES;
        self.navigationController.view.userInteractionEnabled = NO;


        BTBalloon *balloon = [BTBalloon sharedInstance];
        UIView *scaleButtonView = (UIView *)[self.scaleButton performSelector:@selector(view)];
        UIView *chordButtonView = (UIView *)[self.self.chordButton performSelector:@selector(view)];
        UIView *infoButtonView = (UIView *)[self.self.infoButton performSelector:@selector(view)];
        UIView *settingsButtonView = (UIView *)[self.self.settingsButton performSelector:@selector(view)];
        self.view.alpha = 0.25;

        // wait for events to process...
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];

        [balloon showWithTitle:SCALE_TUTORIAL_TEXT image:[UIImage imageNamed:@"SingleTap"] anchorToView:scaleButtonView buttonTitle:@"OK" buttonCallback:^{
            [balloon showWithTitle:CHORD_TUTORIAL_TEXT image:[UIImage imageNamed:@"SingleTap"] anchorToView:chordButtonView buttonTitle:@"OK" buttonCallback:^{
                [balloon showWithTitle:INFO_TUTORIAL_TEXT image:[UIImage imageNamed:@"SingleTap"] anchorToView:infoButtonView buttonTitle:@"OK" buttonCallback:^{
                    [balloon showWithTitle:SETTINGS_TUTORIAL_TEXT image:[UIImage imageNamed:@"SingleTap"] anchorToView:settingsButtonView buttonTitle:@"OK" buttonCallback:^{
                        [balloon hideWithAnimation:YES];
                        [defaults setInteger:YES forKey:RAN_TUTORIAL_KEY];
                        self.navigationController.view.userInteractionEnabled = YES;
                        self.view.alpha = 1.0;
                        self.runningTutorial = NO;
                    }];
                }];
            }];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self tearDownGL];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    SGuitar* sguitar = [SGuitar sharedInstance];

    if (self.isCanvasInitialized && self.context) {
        [sguitar draw];
    }
}

- (void)updateConstraintsForOrientation:(ORIENTATION)orientation {
    if (orientation == O_LANDSCAPE) {
        [self.portraitConstraints autoRemoveConstraints];
        [self.landscapeConstraints autoInstallConstraints];
    } else {
        [self.landscapeConstraints autoRemoveConstraints];
        [self.portraitConstraints autoInstallConstraints];
    }
}

- (void)createLandscapeConstraints {
    self.landscapeConstraints = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        [self.glView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:self.pedalLeverHeight];
        [self.glView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-self.pedalLeverHeight];
        [self.glView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
        [self.glView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
        
        [self.topView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.glView];
        [self.topView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.glView];
        [self.topView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.glView];
        [self.topView autoSetDimension:ALDimensionHeight toSize:PEDAL_LEVER_HEIGHT];
        
        [self.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.glView]; 
        [self.bottomView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.glView];
        [self.bottomView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.glView];
        [self.bottomView autoSetDimension:ALDimensionHeight toSize:PEDAL_LEVER_HEIGHT];
        
        [self.leftLeverView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bottomView];
        [self.leftLeverView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bottomView];
        [self.leftLeverView autoSetDimension:ALDimensionWidth toSize:LEVER_VIEW_WIDTH];
        [self.leftLeverView autoSetDimension:ALDimensionHeight toSize:PEDAL_LEVER_HEIGHT];

        CGSize size = [self sizeForLandscape:self.view.frame.size];
        [self.rightLeverView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bottomView];
        [self.rightLeverView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bottomView withOffset:(size.width - LEVER_VIEW_WIDTH)];
        [self.rightLeverView autoSetDimension:ALDimensionWidth toSize:LEVER_VIEW_WIDTH ];
        [self.rightLeverView autoSetDimension:ALDimensionHeight toSize:PEDAL_LEVER_HEIGHT];

        // pedals
        float left = 2.0;
        for (int i = 0; i < self.pedalButtons.count; i++) {
            UIView *pedal = self.pedalButtons[i];
            [pedal autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.topView withOffset:left];
            [pedal autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.topView withOffset:-6.0];
            [pedal autoSetDimensionsToSize:CGSizeMake(44.0, 44.0)];
            
            UIView *pedalActivated = self.pedalActivatedImageViews[i];
            [pedalActivated autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.topView withOffset:left + 20.0];
            [pedalActivated autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.topView withOffset:-2.0];
            [pedalActivated autoSetDimensionsToSize:CGSizeMake(4.0, 4.0)];
            
            left += 46.0;
        }

        // left levers
        left = 0.0;
        for (int i = LT_LKL; i <= LT_LKRR; i++) {
            int leverVal = i;
            if (i == LT_LKR) {
                leverVal = i + 1;
            } else if (i == LT_LKRR) {
                leverVal = i - 1;
            }

            float offset = -6.0;
            if (i == LT_LKV) {
                offset = 0.0;
            }
            UIView *lever = self.leverButtons[leverVal];
            [lever autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.leftLeverView withOffset:left];
            [lever autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.leftLeverView withOffset:offset];
            [lever autoSetDimensionsToSize:CGSizeMake(44.0, 44.0)];
            
            UIView *leverActivated = self.leverActivatedImageViews[leverVal];
            [leverActivated autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.leftLeverView withOffset:left + 20.0];
            [leverActivated autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.leftLeverView withOffset:-2.0];
            [leverActivated autoSetDimensionsToSize:CGSizeMake(4.0, 4.0)];
            
            left += 45.0;
        }

        // right levers
        left = 0.0;
        for (int i = LT_RKL; i <= LT_RKRR; i++) {
            int leverVal = i;
            if (i == LT_RKR) {
                leverVal = i + 1;
            } else if (i == LT_RKRR) {
                leverVal = i - 1;
            }
            
            float offset = -6.0;
            if (i == LT_RKV) {
                offset = 0.0;
            }
            UIView *lever = self.leverButtons[leverVal];
            [lever autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.rightLeverView withOffset:left];
            [lever autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.rightLeverView withOffset:offset];
            [lever autoSetDimensionsToSize:CGSizeMake(44.0, 44.0)];
            
            UIView *leverActivated = self.leverActivatedImageViews[leverVal];
            [leverActivated autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.rightLeverView withOffset:left + 20.0];
            [leverActivated autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.rightLeverView withOffset:-2.0];
            [leverActivated autoSetDimensionsToSize:CGSizeMake(4.0, 4.0)];
            
            left += 45.0;
        }
        
        
        [self.infoView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
        [self.infoView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
        [self.infoView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
        [self.infoView autoSetDimension:ALDimensionHeight toSize:INFO_VIEW_HEIGHT_ONE_LINE];
    }];
}

- (void)createPortraitConstraints {
    self.portraitConstraints = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        [self.glView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
        [self.glView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
        [self.glView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:self.pedalLeverHeight];
        [self.glView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-self.pedalLeverHeight];

        [self.topView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.glView];
        [self.topView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.glView];
        [self.topView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.glView];
        [self.topView autoSetDimension:ALDimensionWidth toSize:PEDAL_LEVER_HEIGHT];

        [self.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.glView];
        [self.bottomView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.glView];
        [self.bottomView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.glView];
        [self.bottomView autoSetDimension:ALDimensionWidth toSize:PEDAL_LEVER_HEIGHT];

        [self.leftLeverView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bottomView];
        [self.leftLeverView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bottomView];
        [self.leftLeverView autoSetDimension:ALDimensionWidth toSize:PEDAL_LEVER_HEIGHT];
        [self.leftLeverView autoSetDimension:ALDimensionHeight toSize:LEVER_VIEW_WIDTH];
        
        [self.rightLeverView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bottomView];
        [self.rightLeverView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bottomView];
        [self.rightLeverView autoSetDimension:ALDimensionWidth toSize:PEDAL_LEVER_HEIGHT];
        [self.rightLeverView autoSetDimension:ALDimensionHeight toSize:LEVER_VIEW_WIDTH];

        [self.infoView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
        [self.infoView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
        [self.infoView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];

        int left = 2;
        for (int i = 0; i < self.pedalButtons.count; i++) {
            UIView *pedal = self.pedalButtons[i];
            [pedal autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.topView withOffset:left];
            [pedal autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.topView withOffset:6.0];
            [pedal autoSetDimension:ALDimensionHeight toSize:44.0];
            [pedal autoSetDimension:ALDimensionWidth toSize:44.0];
            
            UIView *pedalActivated = self.pedalActivatedImageViews[i];
            [pedalActivated autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.topView withOffset:left + 20.0];
            [pedalActivated autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.topView withOffset:2.0];
            [pedalActivated autoSetDimensionsToSize:CGSizeMake(4.0, 4.0)];
            
            left += 46;
        }
        
        // left levers
        left = 0.0;
        for (int i = LT_LKL; i <= LT_LKRR; i++) {
            int leverVal = i;
            if (i == LT_LKR) {
                leverVal = i + 1;
            } else if (i == LT_LKRR) {
                leverVal = i - 1;
            }
            
            float offset = 6.0;
            if (i == LT_LKV) {
                offset = 0.0;
            }
            UIView *lever = self.leverButtons[leverVal];
            [lever autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.leftLeverView withOffset:left];
            [lever autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.leftLeverView withOffset:offset];
            [lever autoSetDimensionsToSize:CGSizeMake(44.0, 44.0)];
            
            UIView *leverActivated = self.leverActivatedImageViews[leverVal];
            [leverActivated autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.leftLeverView withOffset:left + 20.0];
            [leverActivated autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.leftLeverView withOffset:2.0];
            [leverActivated autoSetDimensionsToSize:CGSizeMake(4.0, 4.0)];
            
            left += 45.0;
        }
        
        // right levers
        left = 0.0;
        for (int i = LT_RKL; i <= LT_RKRR; i++) {
            int leverVal = i;
            if (i == LT_RKR) {
                leverVal = i + 1;
            } else if (i == LT_RKRR) {
                leverVal = i - 1;
            }
            
            float offset = 6.0;
            if (i == LT_RKV) {
                offset = 0.0;
            }
            
            UIView *lever = self.leverButtons[leverVal];
            [lever autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.rightLeverView withOffset:left];
            [lever autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.rightLeverView withOffset:offset];
            [lever autoSetDimensionsToSize:CGSizeMake(44.0, 44.0)];
            
            UIView *leverActivated = self.leverActivatedImageViews[leverVal];
            [leverActivated autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.rightLeverView withOffset:left + 20.0];
            [leverActivated autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.rightLeverView withOffset:2.0];
            [leverActivated autoSetDimensionsToSize:CGSizeMake(4.0, 4.0)];
            
            left += 45.0;
        }

        // if we have enough room in portrait use the one-line landscape display
        CGSize size = [self sizeForPortrait:self.view.frame.size];
        if (size.width >= INFO_VIEW_SCALE_CHORD_WIDTH) {
            [self.infoView autoSetDimension:ALDimensionHeight toSize:INFO_VIEW_HEIGHT_ONE_LINE];
        } else {
            [self.infoView autoSetDimension:ALDimensionHeight toSize:INFO_VIEW_HEIGHT_TWO_LINES];
        }
        
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        ORIENTATION orientation = [self getOrientationForSize:size];
        [self updateConstraintsForOrientation:orientation];
        [self.view setNeedsLayout];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.infoViewController updateDisplay];
    }];
}

- (IBAction)pedalSelected:(UIButton *)sender {
    // the user selected a pdeal
    sender.selected = !sender.selected;
    UIButton *activatedImageView = [self.pedalActivatedImageViews objectAtIndex:sender.tag];
    activatedImageView.hidden = !sender.selected;
    
    NSString *settingID = [self settingIDForPedalTag:sender.tag];
    
    SGuitar* sguitar = [SGuitar sharedInstance];
    [sguitar activateAdjustment:settingID activated:sender.selected];

    
    [self.glView setNeedsDisplay];
}

- (IBAction)leverSelected:(UIButton *)sender {
    // the user selected a lever
    sender.selected = !sender.selected;
    UIButton *activatedImageView = [self.leverActivatedImageViews objectAtIndex:sender.tag];
    activatedImageView.hidden = !sender.selected;

    NSString *settingID = [self settingIDForLeverTag:sender.tag];
    SGuitar* sguitar = [SGuitar sharedInstance];
    [sguitar activateAdjustment:settingID activated:sender.selected];
    
    [self.glView setNeedsDisplay];
}

- (void)rotateViewsForOrientation:(ORIENTATION)orientation {
    // constraints handle the orientation shift but the image buttons need to be rotated to match
    CGAffineTransform transformView;

    if (orientation == O_PORTRAIT) {
        transformView =  CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-270.0));
    } else {
        transformView =  CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0.0));
    }

    for (int i = 0; i < self.pedalButtons.count; i++) {
        UIButton *button = self.pedalButtons[i];
        button.transform = transformView;
    }
    
    for (int i = 0; i < self.leverButtons.count; i++) {
        UIButton *button = self.leverButtons[i];
        button.transform = transformView;
    }
}

//
// lever/pedal translation helpers
- (NSString *)settingIDForPedalTag:(NSInteger)tag {
    NSString *settingID = [SGuitar getPedalTypeName:(int)tag];
    return settingID;
}

- (NSString *)settingIDForLeverTag:(NSInteger)tag {
    NSString *settingID = [SGuitar getLeverTypeName:(int)tag];
    return settingID;
}

- (void)showChordSettings {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chord" bundle:nil];
    UINavigationController *navigationController = [sb instantiateInitialViewController];
    ChordViewController *controller = (ChordViewController *)navigationController.topViewController;
    controller.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self dismissPopover];
        
        controller.inPopover = YES;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        self.popover.delegate = self;
        
        [self.popover presentPopoverFromBarButtonItem:self.chordButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)chordViewControllerResetDisplay {
    [self.glView setNeedsDisplay];
    [self.infoViewController updateDisplay];
}

- (void)chordViewControllerDidFinish:(ChordViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)scaleSelected:(UIBarButtonItem *)sender {
    [self showScaleSettings];
}

- (IBAction)chordSelected:(UIBarButtonItem *)sender {
    [self showChordSettings];
}

- (IBAction)settingsSelected:(id)sender {
    [self showSettings];
}

// scale settings
- (void)showScaleSettings {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Scale" bundle:nil];
    UINavigationController *navigationController = [sb instantiateInitialViewController];
    ScaleViewController *controller = (ScaleViewController *)navigationController.topViewController;
    controller.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self dismissPopover];
        
        controller.inPopover = YES;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        self.popover.delegate = self;
        
        [self.popover presentPopoverFromBarButtonItem:self.scaleButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)scaleViewControllerDidFinish:(ScaleViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)scaleViewControllerResetDisplay {
    [self.glView setNeedsDisplay];
    [self.infoViewController updateDisplay];
}

// global settings
- (void)showSettings {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UINavigationController *navigationController = [sb instantiateInitialViewController];
    SettingsViewController *controller = (SettingsViewController *)navigationController.topViewController;
    controller.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self dismissPopover];
        
        controller.inPopover = YES;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        self.popover.delegate = self;
        
        [self.popover presentPopoverFromBarButtonItem:self.settingsButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)updateAdjustments {
    SGuitar* sguitar = [SGuitar sharedInstance];
    
    for (int pedalID = PT_P1; pedalID <= PT_P10; pedalID++) {
        BOOL enabled = [sguitar isAdjustmentEnabled:[SGuitar getPedalTypeName:pedalID]];
        
        UIButton *curButton = self.pedalButtons[pedalID];
        UIImageView *curImage = self.pedalActivatedImageViews[pedalID];
        curButton.hidden = !enabled;
        
        if (!enabled) {
            curImage.hidden = YES;
        }
    }

    for (int leverID = LT_LKL; leverID <= LT_RKRR; leverID++) {
        BOOL enabled = [sguitar isAdjustmentEnabled:[SGuitar getLeverTypeName:leverID]];
        UIButton *curButton = self.leverButtons[leverID];
        UIImageView *curImage = self.leverActivatedImageViews[leverID];
        curButton.hidden = !enabled;
        
        if (!enabled) {
            curImage.hidden = YES;
        }
    }
}

- (void)settingsViewControllerResetDisplay {
    SGuitar* sguitar = [SGuitar sharedInstance];
    [sguitar reloadGuitar];
    
    ORIENTATION orientation = [self getOrientation];
    [self setupCanvasForOrientation:orientation];
    [self updateAdjustments];
    
    [self.glView setNeedsDisplay];
    [self.infoViewController updateDisplay];
    [self resetTitle];
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    // save the selected guitar and load it again on app startup
    [self setLastGuitar];
}

- (void)setLastGuitar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    SGuitar* sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    
    [defaults setObject:guitarOptions.guitarType forKey:@"guitarType"];
    [defaults setObject:guitarOptions.guitarName forKey:@"guitarName"];
    [defaults synchronize];
}

- (IBAction)infoSelected:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self dismissPopover];
    }

    if (self.infoView.hidden) {
        [self showInfoView];
    } else {
        [self hideInfoView];
    }
}

- (void)settingsViewControllerStartTutorial:(SettingsViewController *)controller {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:NO forKey:RAN_TUTORIAL_KEY];
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self startTutorial];
}

- (void)showInfoView {
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, CGRectGetHeight(self.view.frame) + CGRectGetHeight(self.infoView.frame),
                                     CGRectGetWidth(self.infoView.frame), CGRectGetHeight(self.infoView.frame));
    self.infoView.hidden = NO;
    self.navigationController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5
                          delay:0.05
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.infoView.frame),
                                                          CGRectGetWidth(self.infoView.frame), CGRectGetHeight(self.infoView.frame));
                     }
                     completion:^(BOOL finished) {
                         self.navigationController.view.userInteractionEnabled = YES;
                     }];
}

- (void)hideInfoView {
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.infoView.frame),
                                     CGRectGetWidth(self.infoView.frame), CGRectGetHeight(self.infoView.frame));
    self.navigationController.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.5
                          delay:0.05
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, CGRectGetHeight(self.view.frame) + CGRectGetWidth(self.infoView.frame),
                                                          CGRectGetWidth(self.infoView.frame), CGRectGetHeight(self.infoView.frame));
                     }
                     completion:^(BOOL finished) {
                         self.infoView.hidden = YES;
                         self.navigationController.view.userInteractionEnabled = YES;
                     }];
}

- (void)dismissPopover {
    [self.popover dismissPopoverAnimated:YES];
    [self.popover.delegate popoverControllerDidDismissPopover:self.popover];
    self.popover = nil;
}

- (void)resetTitle {
    SGuitar* sguitar = [SGuitar sharedInstance];
    NSString* name = [sguitar getGuitarOptions].guitarName;
    self.titleLabel.text = name;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popover = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"infoViewContainer"]) {
        self.infoViewController = segue.destinationViewController;
    }
}

@end
