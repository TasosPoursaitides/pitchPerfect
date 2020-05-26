//
//  PlaySoundsViewController.swift
//  PitchPerfect2
//
//  Created by Anastasios Poursaitedes on 25/5/20.
//  Copyright © 2020 Anastasios Poursaitedes. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    //This enumeration helps identify which button was pressed in the second view controller
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //This function prepares the file to be opened
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //The configureUI function enables the buttons so that we can use them for the effects
        configureUI(.notPlaying)
    }
    
    //With the help of the tag that we set on the buttons and the enumeration we consider the button that was pressed
    //and run the playSound function with the appropriate parameter for the effect
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -800)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        //We disable the playback buttons because we're in the middle of playing back
        configureUI(.playing)
    }
    
    @IBAction func stopPlayback(_ sender: UIButton) {
        stopAudio()
    }
}
