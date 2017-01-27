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

    @IBOutlet weak var showScaleMenu: NSMenuItem!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        setupScales();
        setupChords();
        syncToolbarItems();
    }
    
    func setupScales() {
        let sguitar = SGuitar.sharedInstance();
        let scaleNames = sguitar?.getScaleNames();
        
        scaleButton.removeAllItems();
        scaleButton.addItem(withTitle: "");

        for scaleName in scaleNames!  {
            scaleButton.addItem(withTitle: (scaleName as! String));
        }
    }
    
    func setupChords() {
        let sguitar = SGuitar.sharedInstance();
        let chordNames = sguitar?.getChordNames();
        
        chordButton.removeAllItems();
        chordButton.addItem(withTitle: "");
        
        for chordName in chordNames!  {
            chordButton.addItem(withTitle: (chordName as! String));
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
        
        scaleButton.setTitle(scaleName!);
        scaleRootNoteButton.selectItem(at: scaleRootNoteValue)
        scaleRootNoteButton.setTitle(scaleRootNoteValueName!);

        chordButton.setTitle(chordName!);
        chordRootNoteButton.selectItem(at:chordRootNoteValue);
        chordRootNoteButton.setTitle(chordRootNoteValueName!);
    }

    @IBAction func scaleRootNoteButtonSelected(_ sender: NSPopUpButton) {
        scaleRootNoteButton.setTitle(sender.titleOfSelectedItem!);
        let vc = contentViewController as! ViewController
        vc.setScaleRootNoteValue(rootNoteValue: Int32(sender.indexOfSelectedItem - 1));
    }

    @IBAction func showScaleSelected(_ sender: NSMenuItem) {
        let vc = contentViewController as! ViewController
        
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.showScale = !(scaleOptions?.showScale)!;
        
        if (scaleOptions?.showScale)! {
            showScaleMenu.state = NSOnState;
        } else {
            showScaleMenu.state = NSOffState;
        }
        
        vc.view.needsDisplay = true;
    }
    
    @IBAction func chordRootNoteButtonSelected(_ sender: NSPopUpButton) {
        chordRootNoteButton.setTitle(sender.titleOfSelectedItem!);
        let vc = contentViewController as! ViewController
        vc.setChordRootNoteValue(rootNoteValue: Int32(sender.indexOfSelectedItem - 1));
    }

    @IBAction func scaleSelected(_ sender: NSPopUpButton) {
        let scaleName: String = sender.titleOfSelectedItem!;
        scaleButton.setTitle(scaleName);
        let vc = contentViewController as! ViewController
        vc.setScaleName(scaleName:scaleName);
    }
    
    @IBAction func chordSelected(_ sender: NSPopUpButton) {
        let chordName: String = sender.titleOfSelectedItem!;
        chordButton.setTitle(chordName);
        let vc = contentViewController as! ViewController
        vc.setChordName(chordName:chordName);
    }
}
