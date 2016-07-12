//
//  MonsterImg.swift
//  Monster
//
//  Created by Mac Owner on 7/11/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import Foundation
import UIKit
class MonsterImg: UIImageView {
    
    var storedRand = 0
    var chosen = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
        
    }
    
    var monsterType: Int {
        get {
            return storedRand
        }
    }
    
    func playIdleAnimation() {
        
        var imgArray = [UIImage]()
        
        if (chosen == false) {
            let rand = arc4random_uniform(2)
            storedRand = Int(rand)
            chosen = true
        }
        
        if storedRand == 0 {
        
            self.image = UIImage(named: "idle_mole1.png")
            
            self.animationImages = nil
            
            for i in 1...4 {
                let img = UIImage(named: "idle_mole\(i).png")
                imgArray.append(img!)
            }
            
        } else {
            
            self.image = UIImage(named: "idle (1).png")
        
            self.animationImages = nil
        
            for i in 1...4 {
                let img = UIImage(named: "idle (\(i)).png")
                imgArray.append(img!)
            
            }
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        
        var imgArray = [UIImage]()
        
        if storedRand == 0 {
            
            self.image = UIImage(named: "mole_hide6.png")
            
            self.animationImages = nil
            
            for i in 1...6 {
                let img = UIImage(named: "mole_hide\(i).png")
                imgArray.append(img!)
            }
            
        } else {
            
            self.image = UIImage(named: "dead5.png")
            
            self.animationImages = nil
            
            for i in 1...4 {
                let img = UIImage(named: "dead\(i).png")
                imgArray.append(img!)
            }
            
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
}
