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
    

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    weak var whisper : Whisper? {
    didSet{
            print("did set cell\(whisper)   ")
            self.backgroundImage.hnk_setImageFromURL(NSURL(string: (whisper?.backgroundImage)!)!)
            self.contentLabel.text =  whisper?.contentText
        }
    }
    
}




