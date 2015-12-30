//
//  NewWhisperViewController.swift
//  iWhisper
//
//  Created by swift on 15/12/29.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit

class NewWhisperViewController: UIViewController {
    
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var refreshTipBtn: UIButton!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var searchImageBtn: UIButton!
    @IBOutlet weak var whisperContent: UITextView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!


    @IBOutlet weak var canEnterWordsCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelNewWhisper(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
