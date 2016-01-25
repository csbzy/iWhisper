//
//  NewWhisperViewController.swift
//  iWhisper
//
//  Created by swift on 15/12/29.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
class NewWhisperViewController: UIViewController {
    
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var refreshTipBtn: UIButton!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var searchImageBtn: UIButton!
    @IBOutlet weak var whisperContent: UITextView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    var tips = [String]()
    var  scrollID = 0
    var viewStep  = 0 {
        didSet{
            updateStep()
        }
    }

    @IBOutlet weak var canEnterWordsCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        whisperContent.layer.masksToBounds = true
        whisperContent.layer.cornerRadius = 10
        getTips(){}
        viewStep = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelNewWhisper(sender: AnyObject) {
        if viewStep > 0{
            viewStep -= 1
        }else if  viewStep == 0{
            self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        }
    }
    
    @IBAction func doRefreshTip(sender: AnyObject) {
        print("do refresh:\(self.tips.count)")
        if tips.count > 1 {
            displayTip()
        }else{
            getTips(){}
        }
        
    }
    func getTips(completion: () -> Void){
        if tips.count <= 1 {
        let feedParams = ["uid":UID ,"limit":50,"scroll_id": scrollID]
        scrollID += 50
        if(scrollID >= 100){
            scrollID = 0
        }
        Alamofire.request(.GET,WHISPER_TIPS,parameters:feedParams as? [String : AnyObject])
            .responseJSON
            {
                response in
                let json = SwiftyJSON.JSON(response.result.value!)
                for (_,item):(String,SwiftyJSON.JSON) in json["tips"]{
                    self.tips.append(item.string!)
                }
                print("get tips")
                self.displayTip()
                
            }
        }
    }
    
    func displayTip(){
        if self.tips.count > 0 {
        self.tipLabel.text = self.tips.removeAtIndex(0)
        self.tipLabel.hidden = false
        }
    }
    
    
    @IBAction func doNext(sender: AnyObject) {
        if viewStep < 3 {
            viewStep += 1
        }
    }
    
    func  updateStep(){
        switch viewStep{
        case 0 :
            whisperContent.hidden = false
            backgroundImage.hidden = true
            tipLabel.hidden = false
            searchImageBtn.hidden = true
            cameraBtn.hidden  = true

        case 1 :
            backgroundImage.hidden = false
            tipLabel.hidden = true
            searchImageBtn.hidden = false
            cameraBtn.hidden  = false
            
        default :
            backgroundImage.hidden = true
            
        }
        
    }

}
