//
//  InfoView2Controller.swift
//  SteelSidekick
//
//  Created by John Sohn on 1/22/18.
//

import UIKit

func UIColorFromRGB2(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

let NOTE_BACKGROUND: String                 = "Note-Background"
let NOTE_CHORD_BACKGROUND: String           = "Note-ChordBackground"
let NOTE_SCALE_BACKGROUND: String           = "Note-ScaleBackground"
let NOTE_SCALE_CHORD_BACKGROUND: String     = "Note-ScaleChordBackground"

let SCALE_COLOR: UInt                       = 0xA01401
let CHORD_COLOR: UInt                       = 0x0536FF
let SCALE_CHORD_COLOR: UInt                 = 0x751F92

enum SetupNoteType {
    case chord, scale
}

class InfoViewController: UIViewController {
    
    @IBOutlet weak var scaleView: UIView!
    @IBOutlet weak var chordView: UIView!
    @IBOutlet var scaleImages: [UIImageView]!
    @IBOutlet var chordImages: [UIImageView]!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var chordLabel: UILabel!

    var oneLineConstraints: NSArray = []    // constraints in landscape
    var twoLineConstraints: NSArray = []    // constraints in portrait
    var noteImages: [String] = []           // image names for all notes (sharp and flat)
    var noteImagesSharp: [String] = []      // image names for sharp notes
    var noteImagesFlat: [String] = []       // image names for flat notes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoteImages()
        setupContraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLabels()
        setupNoteDisplayImages(images: self.scaleImages, type: SetupNoteType.scale)
        setupNoteDisplayImages(images: self.chordImages, type: SetupNoteType.chord)
        
        // set constraints for initial orientation
        let view:UIView = (self.parent?.view)!
        let orientation  = self.getOrientationFor(view)
        updateConstraintsForOrientation(orientation: orientation)
        self.view.setNeedsLayout()
    }
    
    func setupContraints() {
        createOneLineConstraints()
        createTwoLineConstraints()
    }
    
    func setupLabels() {
        let sguitar:SGuitar = SGuitar.sharedInstance()
        let scaleOptions:SGScaleOptions = sguitar.getScaleOptions()
        let chordOptions:SGChordOptions = sguitar.getChordOptions()
        var scaleName: String = ""
        
        if (scaleOptions.showScale) {
            scaleName = scaleOptions.scaleName
        }
        
        let scaleLabel:String = NSString(format:"Scale: %@", scaleName) as String
        
        var chordName = ""
        if (chordOptions.showChord) {
            chordName = chordOptions.chordName
        }
        
        let chordLabel:String = NSString(format:"Chord: %@", chordName) as String
        
        self.scaleLabel.text = scaleLabel
        self.chordLabel.text = chordLabel
    }
    
    func setupNoteImages() {
        self.noteImages = ["Images/Note-C",
                           "Images/Note-C-Sharp",
                           "Images/Note-D-Flat",
                           "Images/Note-D",
                           "Images/Note-D-Sharp",
                           "Images/Note-E-Flat",
                           "Images/Note-E",
                           "Images/Note-F",
                           "Images/Note-F-Sharp",
                           "Images/Note-G-Flat",
                           "Images/Note-G",
                           "Images/Note-G-Sharp",
                           "Images/Note-A-Flat",
                           "Images/Note-A",
                           "Images/Note-A-Sharp",
                           "Images/Note-B-Flat",
                           "Images/Note-B"]
        
        self.noteImagesSharp = ["Images/Note-C",
                                "Images/Note-C-Sharp",
                                "Images/Note-D",
                                "Images/Note-D-Sharp",
                                "Images/Note-E",
                                "Images/Note-F",
                                "Images/Note-F-Sharp",
                                "Images/Note-G",
                                "Images/Note-G-Sharp",
                                "Images/Note-A",
                                "Images/Note-A-Sharp",
                                "Images/Note-B"]
        
        self.noteImagesFlat = ["Images/Note-C",
                               "Images/Note-D-Flat",
                               "Images/Note-D",
                               "Images/Note-E-Flat",
                               "Images/Note-E",
                               "Images/Note-F",
                               "Images/Note-G-Flat",
                               "Images/Note-G",
                               "Images/Note-A-Flat",
                               "Images/Note-A",
                               "Images/Note-B-Flat",
                               "Images/Note-B"]
    }
    
    func updateDisplay() {
        setupLabels()
        setupNoteDisplayImages(images: self.scaleImages, type: SetupNoteType.scale)
        setupNoteDisplayImages(images: self.chordImages, type: SetupNoteType.chord)
    }
    
    func setupNoteDisplayImages(images: [UIImageView], type: SetupNoteType) {
        let sguitar:SGuitar = SGuitar.sharedInstance()
        let scaleOptions:SGScaleOptions = sguitar.getScaleOptions()
        let chordOptions:SGChordOptions = sguitar.getChordOptions()
        var noteValues:[Int] = []
        
        if (type == SetupNoteType.scale) {  // Scale
            if (scaleOptions.showScale) {
                noteValues = sguitar.getScaleNoteValues() as! Array<Int>
            }
        } else {                    // Chord
            if (chordOptions.showChord) {
                noteValues = sguitar.getChordNoteValues() as! Array<Int>
            }
        }
        
        for i in 0 ..< images.count {
            let image:UIImageView = images[i]
            
            if (i < noteValues.count) {
                let noteValue:Int = noteValues[i]
                image.isHidden = false
                
                var imageName:String = ""
                if (sguitar.getOptions().showNotesAs == ADT_SHARP) {
                    imageName = noteImagesSharp[noteValue]
                } else {
                    imageName = noteImagesFlat[noteValue]
                }
                
                image.image = UIImage(named: imageName)
                var isBoth:Bool = false
                
                if (sguitar.getScaleOptions().showScale && sguitar.getChordOptions().showChord) {
                    if (type == SetupNoteType.scale) {
                        isBoth = sguitar.isNoteValue(inChord:Int32(noteValue))
                    } else {
                        isBoth = sguitar.isNoteValue(inScale:Int32(noteValue))
                    }
                }
                
                if (isBoth) {   // must check for both first
                    image.backgroundColor = UIColorFromRGB2(rgbValue:SCALE_CHORD_COLOR)
                } else if (type == SetupNoteType.scale) {
                    image.backgroundColor = UIColorFromRGB2(rgbValue:SCALE_COLOR)
                } else {
                    image.backgroundColor = UIColorFromRGB2(rgbValue:CHORD_COLOR)
                }
            } else {
                image.isHidden = true
            }
        }
    }
    
    
    // get the safe layout area for iPhone X/iOS 11
    func offsetForInfoView() -> CGFloat {
        var offset:CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            let controller = UIApplication.shared.keyWindow?.rootViewController
            let safeRect = controller?.view.safeAreaLayoutGuide.layoutFrame
            offset = (safeRect?.origin.x)!
            
            // make sure we are not in portrait mode
            if (offset == 0.0) {
                offset = (safeRect?.origin.y)!
            }
        }
        
        return offset
    }
    
    // in landscape use one line for the scale/chord view
    func createOneLineConstraints() {
        let offset:CGFloat = offsetForInfoView()
        self.oneLineConstraints = NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
            scaleView.autoSetDimension(ALDimension.width, toSize: 240.0)
            scaleView.autoSetDimension(ALDimension.height, toSize: CGFloat(INFO_VIEW_SCALE_HEIGHT))
            scaleView.autoPinEdge(ALEdge.top, to: ALEdge.top, of: self.view)
            scaleView.autoPinEdge(ALEdge.left, to:ALEdge.left, of:self.view, withOffset:offset)
            
            chordView.autoSetDimension(ALDimension.width, toSize:240.0)
            chordView.autoSetDimension(ALDimension.height, toSize:CGFloat(INFO_VIEW_CHORD_HEIGHT))
            chordView.autoPinEdge(ALEdge.top, to:ALEdge.top, of:self.view)
            chordView.autoPinEdge(ALEdge.right, to:ALEdge.right, of:self.view, withOffset:-offset)
            } as NSArray
    }
    
    // in portrait use two lines, one for scale and one for chord info
    func createTwoLineConstraints() {
        let offset:CGFloat = offsetForInfoView()
        self.twoLineConstraints = NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
            scaleView.autoSetDimension(ALDimension.height, toSize:CGFloat(INFO_VIEW_SCALE_HEIGHT))
            scaleView.autoPinEdge(ALEdge.top, to:ALEdge.top, of:self.view)
            scaleView.autoPinEdge(ALEdge.left, to:ALEdge.left, of:self.view, withOffset:offset)
            scaleView.autoPinEdge(ALEdge.right, to:ALEdge.right, of:self.view, withOffset:offset)
            
            chordView.autoSetDimension(ALDimension.height, toSize:CGFloat(INFO_VIEW_CHORD_HEIGHT))
            chordView.autoPinEdge(ALEdge.top, to:ALEdge.bottom, of:self.scaleView)
            chordView.autoPinEdge(ALEdge.left, to:ALEdge.left, of:self.view, withOffset:offset)
            chordView.autoPinEdge(ALEdge.right, to:ALEdge.right, of:self.view, withOffset:offset)
            } as NSArray
    }
    
    // update constraints for the current orientation, one line or two lines for displaying chord and scale information
    func updateConstraintsForOrientation(orientation: ORIENTATION) {
        var useOneLine:Bool = false
        
        if (orientation == O_LANDSCAPE) {
            useOneLine = true
        } else if (orientation == O_PORTRAIT) {
            let size:CGSize = self.size(forPortrait:self.parent!.view.frame.size)
            if (size.width >= CGFloat(INFO_VIEW_SCALE_CHORD_WIDTH)) {
                useOneLine = true
            }
        }
        
        if (useOneLine) {
            twoLineConstraints.autoRemoveConstraints()
            oneLineConstraints.autoInstallConstraints()
        } else {
            oneLineConstraints.autoRemoveConstraints()
            twoLineConstraints.autoInstallConstraints()
        }
    }
    
    // update constraints on orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            let orientation:ORIENTATION  = self.getOrientationFor(size)
            self.updateConstraintsForOrientation(orientation: orientation)
            self.view.setNeedsLayout()
        }) { [unowned self] _ in
            self.updateDisplay()
        }
    }
}
