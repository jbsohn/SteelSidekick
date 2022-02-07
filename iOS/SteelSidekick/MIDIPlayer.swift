//
//  MIDIPlayer.swift
//
//  Created by John on 11/23/21.
//

import Foundation
import AVFoundation

@objc
class MIDIPlayer: NSObject {

    class Sound: NSObject {
        var name: String
        var channel: UInt8
        var patch: UInt8
        
        init(name: String, channel: UInt8, patch: UInt8) {
            self.name = name
            self.channel = channel
            self.patch = patch
        }
    }

    @objc
    public static let shared = MIDIPlayer()

    private var engine:AVAudioEngine = AVAudioEngine()
    private var sampler:AVAudioUnitSampler = AVAudioUnitSampler()

    @objc
    public var soundNames: [String] {
        get {
            return sounds.map { $0.name }
        }
    }

    @objc
    var velocity: UInt8 = 64

    private var sounds: [Sound] = [
        Sound(name:"Nylon Guitar", channel: 0, patch: 24),
        Sound(name:"Steel Guitar", channel: 0, patch: 25),
        Sound(name:"Jazz Guitar", channel: 0, patch: 26),
        Sound(name:"Clean Guitar", channel: 0, patch: 27),
        Sound(name:"Muted Guitar", channel: 0, patch: 28),
        Sound(name:"Overdrive Guitar", channel: 0, patch: 29),
        Sound(name:"Distortion Guitar", channel: 0, patch: 30),
        Sound(name:"Guitar Harmonics", channel: 0, patch: 21),
        Sound(name:"Hawaiian Guitar", channel: 8, patch: 26)
    ]

    private override init() {
    }

    @objc
    public func start() throws {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        try engine.start()
    }

    
    @objc
    public func loadSound(name: String) throws {
        guard let index = sounds.firstIndex(where: { $0.name == name }) else { return }
        let patch = sounds[index];
        try loadPatch(gmpatch: patch.patch, channel: patch.channel)
    }
    
    private func loadPatch(gmpatch:UInt8, channel:UInt8 = 0) throws {
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
        sampler.startNote(note, withVelocity: velocity, onChannel: 1)
    }

    @objc
    public func stopNote(_ note: UInt8) {
        sampler.stopNote(note, onChannel: 1)
    }
    
    @objc func stopAllNotes() {
        for note: UInt8 in 0...127 {
            sampler.stopNote(note, onChannel: 1)
        }
    }
    
}

