//
//  AppDelegate.swift
//  SteelSidekick
//
//  Created by John Sohn on 1/15/17.
//  Copyright © 2017 John Sohn. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var showScaleMenu: NSMenuItem!
    @IBOutlet weak var showChordMenu: NSMenuItem!
    @IBOutlet weak var showAsNotesMenu: NSMenuItem!
    @IBOutlet weak var showAsIntervalsMenu: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        syncMenuItems();
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }


    func syncMenuItems() {
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        let chordOptions = sguitar?.getChordOptions();

        setDisplayItemAsMenu(type: (scaleOptions?.displayItemsAs)!);
        setMenuState(menuItem: showChordMenu, status: (chordOptions?.showChord)!);
        setMenuState(menuItem: showScaleMenu, status: (scaleOptions?.showScale)!);
    }

    func updateViewController() {
        let mainWindow = NSApplication.shared().windows[0];
        let wc = mainWindow.windowController as! WindowController;
        let vc = mainWindow.contentViewController as! ViewController;
        
        wc.syncToolbarItems();
        vc.view.needsDisplay = true;
        
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

