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
    @IBOutlet weak var showChordMenu: NSMenuItem!
    @IBOutlet weak var showAsNotesMenu: NSMenuItem!
    @IBOutlet weak var showAsIntervalsMenu: NSMenuItem!

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
        let scaleRootNoteValue: Int = Int(scaleOptions!.scaleRootNoteValue);
        let scaleRootNoteValueName = SGuitar.getNoteNameSharpFlat(Int32(scaleRootNoteValue));

        let chordOptions = sguitar?.getChordOptions()
        let chordName = chordOptions?.chordName;
        let chordRootNoteValue: Int = Int(chordOptions!.chordRootNoteValue);
        let chordRootNoteValueName = SGuitar.getNoteNameSharpFlat(Int32(chordRootNoteValue));
        
        scaleButton.setTitle(scaleName!);
        scaleRootNoteButton.selectItem(at: scaleRootNoteValue)
        scaleRootNoteButton.setTitle(scaleRootNoteValueName!);

        chordButton.setTitle(chordName!);
        chordRootNoteButton.selectItem(at:chordRootNoteValue);
        chordRootNoteButton.setTitle(chordRootNoteValueName!);
        
        setDisplayItemAsMenu(type: (scaleOptions?.displayItemsAs)!);
        setMenuState(menuItem: showChordMenu, status: (chordOptions?.showChord)!);
        setMenuState(menuItem: showScaleMenu, status: (scaleOptions?.showScale)!);
    }

    func setDisplayItemAsMenu(type: DISPLAY_ITEM_AS_TYPE) {
        if (type == DIA_NOTES) {
            showAsNotesMenu.state = NSOnState;
            showAsIntervalsMenu.state = NSOffState;
        } else if (type == DIA_INTERVAL) {
            showAsNotesMenu.state = NSOffState;
            showAsIntervalsMenu.state = NSOnState;
        }
    }
    
    func setMenuState(menuItem: NSMenuItem, status: Bool) {
        if (status) {
            menuItem.state = NSOnState;
        } else {
            menuItem.state = NSOffState;
        }
    }

    func updateViewController() {
        let vc = contentViewController as! ViewController
        let ad = NSApplication.shared().delegate as? AppDelegate
        ad?.syncMenuItems();
        vc.view.needsDisplay = true;
    }
    
    @IBAction func scaleRootNoteButtonSelected(_ sender: NSPopUpButton) {
        scaleRootNoteButton.setTitle(sender.titleOfSelectedItem!);

        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.scaleRootNoteValue = Int32(sender.indexOfSelectedItem - 1);

        updateViewController();
    }

    @IBAction func scaleSelected(_ sender: NSPopUpButton) {
        let scaleName: String = sender.titleOfSelectedItem!;
        scaleButton.setTitle(scaleName);
        
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.scaleName = scaleName;

        updateViewController();
    }
    
    @IBAction func chordRootNoteButtonSelected(_ sender: NSPopUpButton) {
        chordRootNoteButton.setTitle(sender.titleOfSelectedItem!);
        
        let sguitar = SGuitar.sharedInstance();
        let chordOptions = sguitar?.getChordOptions();
        chordOptions?.chordRootNoteValue = Int32(sender.indexOfSelectedItem - 1);

        updateViewController();
    }

    @IBAction func chordSelected(_ sender: NSPopUpButton) {
        let chordName: String = sender.titleOfSelectedItem!;
        chordButton.setTitle(chordName);
        
        let sguitar = SGuitar.sharedInstance();
        let chordOptions = sguitar?.getChordOptions();
        chordOptions?.chordName = chordName;

        updateViewController();
    }
    
    @IBAction func showScaleSelected(_ sender: NSMenuItem) {
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.showScale = !(scaleOptions?.showScale)!;
        setMenuState(menuItem: showScaleMenu, status: (scaleOptions?.showScale)!);
        updateViewController();
    }
    
    @IBAction func showChordSelected(_ sender: NSMenuItem) {
        let sguitar = SGuitar.sharedInstance();
        let chordOptions = sguitar?.getChordOptions();
        chordOptions?.showChord = !(chordOptions?.showChord)!;
        
        setMenuState(menuItem: showChordMenu, status: (chordOptions?.showChord)!);
        updateViewController();
    }
    
    @IBAction func showAsIntervalsSelected(_ sender: NSMenuItem) {
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.displayItemsAs = DIA_INTERVAL;

        setDisplayItemAsMenu(type: DIA_INTERVAL);
        updateViewController();
    }
    
    @IBAction func showAsNotesSelected(_ sender: NSMenuItem) {
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.displayItemsAs = DIA_NOTES;
        setDisplayItemAsMenu(type: DIA_NOTES);
        updateViewController();
    }
}
