//
//  RecordAudioViewController.swift
//  PitchPerfect2
//
//  Created by Anastasios Poursaitedes on 25/5/20.
//  Copyright © 2020 Anastasios Poursaitedes. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopbutton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    //A function to hide the appropriate button(Record or Stop)
    func hideAndShowButtons(hide button1: UIButton, show button2: UIButton ) {
        button1.isHidden = true
        button2.isHidden = false
    }
    
    func updateRecordingLabel(message: String) {
        recordingLabel.text = message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //At the beginning of the app, the stopButton is hidden
        hideAndShowButtons(hide: stopbutton, show: recordButton)
        updateRecordingLabel(message: "Tap To Record")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func startRecording(_ sender: UIButton) {
        //print("The recording has started")
        hideAndShowButtons(hide: recordButton, show: stopbutton)
        updateRecordingLabel(message: "Recording...")
        
        //Constructing the path to where the audio file will be saved and setup its name
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let filePath = URL(string: "\(dirPath)/\(recordingName)")
        
        //The Audio Session will communicate with the hardware in order to specify how audio will be used the the app
        let session = AVAudioSession.sharedInstance()
        
        //Here we specify exactly how are we going to use audio. We will record it and play it from the speaker
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        //Initialization of the audioRecorder which will give us the audio recording capability
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        
        //We start the recording
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        //print("The recording has stopped")
        hideAndShowButtons(hide: stopbutton, show: recordButton)
        updateRecordingLabel(message: "Tap To Record")
        
        //We stop the recording
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Error in recording")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
}
