//
//  WindowController.swift
//  SteelSidekick
//
//  Created by John Sohn on 1/20/17.
//  Copyright © 2017 John Sohn. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    @IBOutlet weak var scaleButton: NSPopUpButton!
    @IBOutlet weak var scaleRootNoteButton: NSPopUpButton!
    @IBOutlet weak var chordButton: NSPopUpButton!
    @IBOutlet weak var chordRootNoteButton: NSPopUpButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.setupScales();
        self.setupChords();
        self.syncToolbarItems();
    }
    
    func setupScales() {
        let sguitar = SGuitar.sharedInstance();
        let scaleNames = sguitar?.getScaleNames();
        
        self.scaleButton.removeAllItems();
        self.scaleButton.addItem(withTitle: "");

        for scaleName in scaleNames!  {
            self.scaleButton.addItem(withTitle: (scaleName as! String));
        }
    }
    
    func setupChords() {
        let sguitar = SGuitar.sharedInstance();
        let chordNames = sguitar?.getChordNames();
        
        self.chordButton.removeAllItems();
        self.chordButton.addItem(withTitle: "");
        
        for chordName in chordNames!  {
            self.chordButton.addItem(withTitle: (chordName as! String));
        }
    }

    func syncToolbarItems() {
        let sguitar = SGuitar.sharedInstance();
        
        let scaleOptions = sguitar?.getScaleOptions()
        let scaleName = scaleOptions?.scaleName;
        let scaleRootNoteValue: Int = Int(scaleOptions!.scaleRoteNoteValue);
        let scaleRootNoteValueName = NoteName.getSharpFlat(Int32(scaleRootNoteValue));

        let chordOptions = sguitar?.getChordOptions()
        let chordName = chordOptions?.chordName;
        let chordRootNoteValue: Int = Int(chordOptions!.chordRoteNoteValue);
        let chordRootNoteValueName = NoteName.getSharpFlat(Int32(chordRootNoteValue));
        
        self.scaleButton.setTitle(scaleName!);
        self.scaleRootNoteButton.selectItem(at: scaleRootNoteValue)
        self.scaleRootNoteButton.setTitle(scaleRootNoteValueName!);

        self.chordButton.setTitle(chordName!);
        self.chordRootNoteButton.selectItem(at:chordRootNoteValue);
        self.chordRootNoteButton.setTitle(chordRootNoteValueName!);
    }

    @IBAction func scaleRootNoteButtonSelected(_ sender: NSPopUpButton) {
        self.scaleRootNoteButton.setTitle(sender.titleOfSelectedItem!);
        let vc = self.contentViewController as! ViewController
        vc.setScaleRootNoteValue(rootNoteValue: Int32(sender.indexOfSelectedItem - 1));
    }

    @IBAction func chordRootNoteButtonSelected(_ sender: NSPopUpButton) {
        self.chordRootNoteButton.setTitle(sender.titleOfSelectedItem!);
        let vc = self.contentViewController as! ViewController
        vc.setChordRootNoteValue(rootNoteValue: Int32(sender.indexOfSelectedItem - 1));
    }

    @IBAction func scaleSelected(_ sender: NSPopUpButton) {
        let scaleName: String = sender.titleOfSelectedItem!;
        self.scaleButton.setTitle(scaleName);
        let vc = self.contentViewController as! ViewController
        vc.setScaleName(scaleName:scaleName);
    }
    
    @IBAction func chordSelected(_ sender: NSPopUpButton) {
        let chordName: String = sender.titleOfSelectedItem!;
        self.chordButton.setTitle(chordName);
        let vc = self.contentViewController as! ViewController
        vc.setChordName(chordName:chordName);
    }
}
