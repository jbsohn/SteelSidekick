//
//  MIDIPlayer.swift
//
//  Created by John on 11/23/21.
//

import Foundation
import AVFoundation

@objc
class MIDIPlayer: NSObject {

    @objc
    public static let shared = MIDIPlayer()

    private var engine:AVAudioEngine = AVAudioEngine()
    private var sampler:AVAudioUnitSampler = AVAudioUnitSampler()

    private override init() {
        
    }

    @objc
    public func start() throws {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        try engine.start()
    }
    
    @objc
    public func loadPatch(gmpatch:UInt8, channel:UInt8 = 0) throws {
        guard let soundbank = Bundle.main.url(forResource: "GeneralUser GS v1.471", withExtension: "sf2") else {
            throw NSError(domain: "Could not load soundfont", code: -1, userInfo: nil)
        }
        let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
        let bankLSB = UInt8(kAUSampler_DefaultBankLSB)
        try sampler.loadSoundBankInstrument(at: soundbank, program:gmpatch, bankMSB: melodicBank, bankLSB: bankLSB)
        sampler.sendProgramChange(gmpatch, bankMSB: melodicBank, bankLSB: bankLSB, onChannel: channel)
    }
    
    @objc
    public func playNote(_ note: UInt8) {
        sampler.startNote(note, withVelocity: 64, onChannel: 1)
    }

    @objc
    public func stopNote(_ note: UInt8) {
        sampler.stopNote(note, onChannel: 1)
    }
    
}

