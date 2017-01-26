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
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func showScaleSelected(_ sender: NSMenuItem) {
        let mainWindow = NSApplication.shared().windows[0];
        let vc = mainWindow.contentViewController as! ViewController

        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.showScale = !(scaleOptions?.showScale)!;
        
        if (scaleOptions?.showScale)! {
            self.showScaleMenu.state = NSOnState;
        } else {
            self.showScaleMenu.state = NSOffState;
        }
        
        vc.view.needsDisplay = true;
    }
    
    @IBAction func showChordSelected(_ sender: NSMenuItem) {
        let mainWindow = NSApplication.shared().windows[0];
        let vc = mainWindow.contentViewController as! ViewController
        
        self.showChordMenu.state = NSOnState;
        
        let sguitar = SGuitar.sharedInstance();
        let chordOptions = sguitar?.getChordOptions();
        chordOptions?.showChord = !(chordOptions?.showChord)!;
        
        if (chordOptions?.showChord)! {
            self.showChordMenu.state = NSOnState;
        } else {
            self.showChordMenu.state = NSOffState;
        }
        
        vc.view.needsDisplay = true;
    }

    @IBAction func showAsIntervalsSelected(_ sender: NSMenuItem) {
        let mainWindow = NSApplication.shared().windows[0];
        let vc = mainWindow.contentViewController as! ViewController
        
        self.showAsNotesMenu.state = NSOffState;
        self.showAsIntervalsMenu.state = NSOnState;
        
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.displayItemAs = DIA_INTERVAL;
        vc.view.needsDisplay = true;
    }
    
    @IBAction func showAsNotesSelected(_ sender: NSMenuItem) {
        let mainWindow = NSApplication.shared().windows[0];
        let vc = mainWindow.contentViewController as! ViewController

        self.showAsNotesMenu.state = NSOnState;
        self.showAsIntervalsMenu.state = NSOffState;
        
        let sguitar = SGuitar.sharedInstance();
        let scaleOptions = sguitar?.getScaleOptions();
        scaleOptions?.displayItemAs = DIA_NOTES;
        vc.view.needsDisplay = true;
    }
}

