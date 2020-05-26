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
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    /*This well thought suggested by the Udacity Reviewer function checkes if the a recording is happening
      and if so it configures the buttons and the label's text accordingly*/
    func configureUI(isRecording: Bool) {
        stopRecordingButton.isEnabled = isRecording // to disable the button
        recordButton.isEnabled = !isRecording // to enable the button
        recordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI(isRecording: false)
    }

    @IBAction func startRecording(_ sender: UIButton) {
        //print("The recording has started")
        
        //We enable the stopRecording button button and update the label's text
        configureUI(isRecording: true)
        
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
        
        //We enable again the recordButton button so that we can record again
        configureUI(isRecording: false)
        
        //We stop the recording
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    /*We check if the recording has completed successfully and if so we're getting ready to proceed to the next view
      or else we print an error message*/
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Error in recording")
        }
    }
    
    //We preparing the view for the transition to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
}
