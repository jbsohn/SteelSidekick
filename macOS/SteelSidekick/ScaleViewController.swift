//
//  ScaleViewController.swift
//  SteelSidekick
//
//  Created by John Sohn on 1/18/17.
//  Copyright © 2017 John Sohn. All rights reserved.
//

import Cocoa

protocol ScaleViewControllerDelegate {
    func didUpdateScaleSettings();
}

class ScaleViewController: NSViewController {

    @IBOutlet weak var scaleButton: NSPopUpButton!
    @IBOutlet weak var rootNoteButton: NSPopUpButton!

//    var delegate: ScaleViewControllerDelegate;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sguitar = SGuitar.sharedInstance();

        let scaleOptions = sguitar?.getScaleOptions();
        let rootNote = (scaleOptions?.scaleRootNoteValue)!;

        // init scales
        let scales = (sguitar?.getScaleNames()) as! [String];
        self.scaleButton.removeAllItems();
        self.scaleButton.addItems(withTitles:scales);
        //self.scaleButton.selectItem(at:Int(rootNote));
    
        // init root notes
        self.rootNoteButton.removeAllItems();
        for i in NOTE_VALUE_C...NOTE_VALUE_B {
            let noteName = SGuitar.getNoteNameSharpFlat(Int32(i));
            self.rootNoteButton.addItem(withTitle:noteName!);
        }
        
        self.rootNoteButton.selectItem(at:Int(rootNote));
    }
    
    override func viewDidDisappear() {
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        
        let scaleRootNoteValue = self.rootNoteButton.indexOfSelectedItem
        scaleOptions?.scaleRootNoteValue = Int32(scaleRootNoteValue);
    }
    
}
