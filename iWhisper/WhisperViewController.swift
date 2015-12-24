//
//  ViewController.swift
//  iWhisper
//
//  Created by swift on 15/12/22.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class WhisperViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var WhisperScrollView: UIScrollView!
    
    @IBOutlet weak var topBarView: UIToolbar!
    
    var feeds = [Feed]()
    var  whispers = [[Whisper]]()
    var  feedsViews = [UITableView]()
    var keyValue = Dictionary<UITableView,Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WhisperConfig.sharedInstance.config
        
        let feedJsons = config!["feeds"]
        
        let nib = UINib(nibName: "WhisperCell", bundle: nil)
        
        
       
        
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        let Width  =  WhisperScrollView.frame.size.width 
        let Height = WhisperScrollView.frame.size.height
        print("scroll view \(Width),\(Height)\n screen view \(width) \(height)  \(WhisperScrollView.frame.origin.x)")
        var index = 0
        for (_,feed):(String,SwiftyJSON.JSON) in feedJsons{
            let View = UITableView()
            feeds.append(Feed(json: feed))
            let startX = (CGFloat(index) * width )
            View.frame = CGRectMake( WhisperScrollView.frame.origin.x + startX ,WhisperScrollView.frame.origin.y 	,width - WhisperScrollView.frame.origin.x,height)
            View.registerClass(WhisperCell.self,forCellReuseIdentifier:"WhisperCell")
            View.registerNib(nib, forCellReuseIdentifier: "WhisperCell")
            WhisperScrollView.addSubview(View)
            keyValue[View] = index
            feedsViews.append(View)
            View.dataSource = self
            View.delegate = self
            View.estimatedRowHeight = 300
            View.rowHeight = UITableViewAutomaticDimension
            index += 1
            
        }
        let contentW: CGFloat = (CGFloat(feedJsons.array!.count) *  width)
        WhisperScrollView.contentSize = CGSizeMake(contentW,0)
        WhisperScrollView.pagingEnabled = true
        WhisperScrollView.delegate  = self
        initData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func initData(){
        for i in 0...(feedsViews.count - 1){
            getWhisperData(i)
        }
    }
    
    func getWhisperData(index:Int){
        print("get whisper data\(index)")
        var feedParams = Dictionary<String,AnyObject>()
        if( feeds[index].needLocation != nil) {
            feedParams = ["feed_id":feeds[index].id!, "type":feeds[index].type!,"limit":LIMIT,"uid":UID,"lat":22.54911,"lon":113.942959]
            
        }else{
            feedParams = ["feed_id":feeds[index].id!, "type":feeds[index].type!, "limit":LIMIT,"uid":UID]
            
        }
        Alamofire.request(.GET,WHISPER_FEED,parameters:feedParams)
            .responseJSON
            {
                response in
                let json = SwiftyJSON.JSON(response.result.value!)
                var whispersInIndex = [Whisper]()
                for (_,item):(String,SwiftyJSON.JSON) in json["whispers"]{
                    let whisper = Whisper(json:item)
                    whispersInIndex.append(whisper)
                }
                self.whispers.append(whispersInIndex)
                print("reload data")
                self.feedsViews[index].reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return ( WhisperScrollView.frame.size.height / 3)

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let index = keyValue[tableView]
        if index < whispers.count   {
            return whispers[index!].count
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = keyValue[tableView]
        let cell = tableView.dequeueReusableCellWithIdentifier("WhisperCell", forIndexPath: indexPath) as! WhisperCell
        if index < whispers.count   {
            cell.whisper = whispers[index!][indexPath.row]
        }

        return cell
    }

}

//
//private var PERSON_ID_NUMBER_PROPERTY = 0
//
//extension UITableView {
//    var  whisperIndex : Int{
//               get{
//                let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int
//                if result == nil {
//                    return 0
//                }
//                return result!
//            }
//            set{
//                objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//            }
//            
//        }
//    
//}
