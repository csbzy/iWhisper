//
//  SplashViewController.swift
//  iWhisper
//
//  Created by swift on 15/12/22.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class SplashViewController: UIViewController {
    
    @IBOutlet weak var splashView: UIWebView!
    var  splashHtmlUrl :String? {
        didSet{
            showSplashHtml()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var navController: UINavigationController!

    //本视图显示前
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    //本视图显示后动作
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.commitAnimations()
        //启动一个定时器,到时间后执行 presentNextViewController: 方法
        NSTimer.scheduledTimerWithTimeInterval(TIME_DURATION, target: self, selector: "presentNextViewController:", userInfo: self.navController, repeats: false)
    }
    
    func showSplashHtml() {
        print("display url\(self.splashHtmlUrl)", terminator: "")
        self.splashView.loadRequest( NSURLRequest(URL: NSURL(string: self.splashHtmlUrl!)!))
    }
    
    //动画显示完毕后,把页面跳转到主视图
    func presentNextViewController(timer:NSTimer){
        print("\(timer.userInfo as? UINavigationController)", terminator: "")
        let rootNavigationViewController:UINavigationController = timer.userInfo as! UINavigationController
        self.presentViewController(rootNavigationViewController, animated: true) { () -> Void in
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func setSplashUrl(url:String){
        self.splashHtmlUrl = url
    }
    class func getSplashViewInstance(navController: UINavigationController)-> SplashViewController    {
        let instance = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SplashView") as! SplashViewController
        instance.navController  = navController
        return  instance
    }

    
}