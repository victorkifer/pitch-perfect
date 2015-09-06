//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Victor on 9/5/15.
//  Copyright (c) 2015 Victor Kifer. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var btnStartRecording: UIButton!
    @IBOutlet weak var btnStopRecording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        btnStartRecording.enabled = true
        btnStopRecording.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        lblRecording.hidden = false
        btnStartRecording.enabled = false
        btnStopRecording.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL:filePath, settings:nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        btnStartRecording.enabled = true
        
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playAudioVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playAudioVC.recordedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            var recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
}

