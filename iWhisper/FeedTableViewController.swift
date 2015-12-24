//
//  FeedTaleViewController.swift
//  iWhisper
//
//  Created by swift on 15/12/23.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FeedTableViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    
    var  whispers = [Whisper]()
    weak var  whisperTableView :UITableView?{
        didSet{
            whisperTableView?.delegate = self
            whisperTableView?.dataSource    = self
            initData()
            super.viewDidLoad()
            let nib = UINib(nibName: "WhisperCell", bundle: nil)
            self.whisperTableView!.registerNib(nib, forCellReuseIdentifier: "WhisperCell")
            whisperTableView!.estimatedRowHeight = whisperTableView!.rowHeight
            whisperTableView!.rowHeight = UITableViewAutomaticDimension
        }
    }
    var feed : Feed?{
        didSet{
            print("set feed", terminator: "")
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData(){
        
        getWhisperData()
    }
    
    func getWhisperData(){
        print("get whisper data", terminator: "")
        var feedParams = Dictionary<String,AnyObject>()
        if( self.feed!.needLocation != nil) {
            feedParams = ["feed_id":self.feed!.id!, "type":self.feed!.type!,"limit":LIMIT,"uid":UID,"lat":22.54911,"lon":113.942959]

        }else{
            feedParams = ["feed_id":self.feed!.id!, "type":self.feed!.type!, "limit":LIMIT,"uid":UID]

        }
            Alamofire.request(.GET,WHISPER_FEED,parameters:feedParams)
                .responseJSON
                {
                    response in
                    let json = SwiftyJSON.JSON(response.result.value!)
                    for (_,item):(String,SwiftyJSON.JSON) in json["whispers"]{
                        let whisper = Whisper(json:item)
                        self.whispers.append(whisper)
                    }
                    print("reload data")
                    self.whisperTableView!.reloadData()
            }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let nib = UINib(nibName: "WhisperCell", bundle: nil)
        self.whisperTableView!.registerNib(nib, forCellReuseIdentifier: "WhisperCell")
        whisperTableView!.estimatedRowHeight = whisperTableView!.rowHeight
        whisperTableView!.rowHeight = UITableViewAutomaticDimension
        print("view did load", terminator: "")
        initData()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        
        super.viewWillAppear(animated)
        
    }

//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return whispers.count
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
////        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("dispaly", terminator: "")
        let cell = tableView.dequeueReusableCellWithIdentifier("WhisperCell", forIndexPath: indexPath) as! WhisperCell
//
//        cell.joke = jokes[indexPath.row]
//        cell.viewController = self
//        //快到底部 加载 下一页的内容
//        let index =  Int(Double(jokes.count) * 0.9)
//        if index == indexPath.row{
//            getJokeData()
//        }
//        cell.updateConstraintsIfNeeded()
        print("display", terminator: "")
        cell.whisper = whispers[indexPath.row]
        return cell
    }
    
}
