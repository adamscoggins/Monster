//
//  ViewController.swift
//  Monster
//
//  Created by Mac Owner on 7/11/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var initialView: UIView!
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var icecreamImg: DragImg!
   
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableRestartButton()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        icecreamImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        let monsterInt = monsterImg.monsterType
        
        if (monsterInt == 0 ) {
            // Mole
        } else {
            // Golem
            background.image = UIImage(named: "golemBg.png")
        }
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        // Handle all audio
        do {
            let cavePath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!)
            try musicPlayer = AVAudioPlayer(contentsOfURL: cavePath)
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        heartImg.alpha = DIM_ALPHA
        icecreamImg.alpha = DIM_ALPHA
        icecreamImg.userInteractionEnabled = false
        foodImg.userInteractionEnabled = false
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
        
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties += 1
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
                return
            }
        }
        
        let rand = arc4random_uniform(3) // Can only get 0 or 1 or 2
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            icecreamImg.alpha = DIM_ALPHA
            icecreamImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else if rand == 1 {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            icecreamImg.alpha = DIM_ALPHA
            icecreamImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        } else {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            icecreamImg.alpha = OPAQUE
            icecreamImg.userInteractionEnabled = true
            
        }
        
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        
        foodImg.alpha = DIM_ALPHA
        icecreamImg.alpha = DIM_ALPHA
        heartImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        icecreamImg.userInteractionEnabled = false
        heartImg.userInteractionEnabled = false
        
        enableRestartButton()
    }
    
    
    @IBAction func restartBtnPressed(sender: UIButton) {
        disableRestartButton()
        restartGame();
    }
    
    func restartGame() {
        penalties = 0
        monsterHappy = false
        heartImg.alpha = OPAQUE
        heartImg.userInteractionEnabled = true
        icecreamImg.alpha = OPAQUE
        icecreamImg.userInteractionEnabled = true
        foodImg.alpha = OPAQUE
        foodImg.userInteractionEnabled = true
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        monsterImg.playIdleAnimation()
        
        startTimer()
        
    }
    
    func enableRestartButton() {
        restartBtn.hidden = false
        restartBtn.enabled = true
    }
    
    func disableRestartButton() {
        restartBtn.hidden = true
        restartBtn.enabled = false
    }
    
    

}

