//
//  WhisperCell.swift
//  iWhisper
//
//  Created by swift on 15/12/23.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import Haneke

class WhisperCell: UITableViewCell {
    
    @IBOutlet weak var setView: UIView!

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var transperentView: UIView!
    
    @IBOutlet weak var me2: UIButton!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    weak var whisper : Whisper? {
    didSet{
        setView.layer.masksToBounds = true
        setView.layer.cornerRadius = 3
        //self.backgroundImage.layoutIfNeeded()
        
        self.backgroundImage.hnk_setImageFromURL(NSURL(string: (whisper?.backgroundImage)!)! )/*, format: Format<UIImage>(name: "original"),success:{
            image  in
            self.backgroundImage.image = image
            self.backgroundImage.contentMode = UIViewContentMode.Redraw
        })*/
        

        self.transperentView.alpha = 0.4
        self.transperentView.backgroundColor = UIColor.grayColor()
        
        self.transperentView.superview!.sendSubviewToBack(self.transperentView)
        self.backgroundImage.superview!.sendSubviewToBack(self.backgroundImage)
        
        
        self.contentLabel.text =  whisper?.contentText
        contentLabel.superview?.bringSubviewToFront(contentLabel)
        self.distanceLabel.text = whisper?.distanceText!
        self.me2.setTitle( "♡\((whisper?.me2Count)!)" ,forState: UIControlState.Normal)
        self.me2.setTitle( "❤︎\((whisper?.me2Count)!)" ,forState: UIControlState.Selected)
        self.replyCount.text = "\((whisper?.replies)!)回复"
        }
    }
    
}




