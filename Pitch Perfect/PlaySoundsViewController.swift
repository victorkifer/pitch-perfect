//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Victor on 9/6/15.
//  Copyright (c) 2015 Victor Kifer. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioEngine:AVAudioEngine!
    var audioPlayer:AVAudioPlayer!
    var recordedAudio:RecordedAudio!
    
    var audioFile:AVAudioFile!

    @IBOutlet weak var btnPlaySlow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl!, error: nil)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        stopPlayer()
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    @IBAction func playAudioFast(sender: UIButton) {
        stopPlayer()
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopPlayer()
    }
    
    func stopPlayer() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playAudioChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playAudioDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    func playAudioWithVariablePitch(pitch: Float){
        stopPlayer()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
