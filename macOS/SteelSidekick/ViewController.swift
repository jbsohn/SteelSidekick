//
//  ViewController.swift
//  SteelSidekick
//
//  Created by John Sohn on 1/15/17.
//  Copyright © 2017 John Sohn. All rights reserved.
//

import Cocoa
import OpenGL.GL3

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    }
    
    func setScaleRootNoteValue(rootNoteValue: Int32) {
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.scaleRoteNoteValue = rootNoteValue;
        view.needsDisplay = true;
    }

    func setChordRootNoteValue(rootNoteValue: Int32) {
        let sguitar = SGuitar.sharedInstance();
        let chordOptions = sguitar?.getChordOptions();
        chordOptions?.chordRoteNoteValue = rootNoteValue;
        view.needsDisplay = true;
    }
    
    func setScaleName(scaleName: String) {
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.scaleName = scaleName;
        view.needsDisplay = true;
    }

    func setChordName(chordName: String) {
        let sguitar = SGuitar.sharedInstance();
        let chordOptions = sguitar?.getChordOptions();
        chordOptions?.chordName = chordName;
        view.needsDisplay = true;
    }
    
}
