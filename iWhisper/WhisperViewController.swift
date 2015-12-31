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

class WhisperViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource	{
    
    @IBOutlet weak var whisperScrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topLabelScrollView: UIScrollView!
    @IBOutlet weak var personInfoButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var addWhisperButton: UIButton!
   
    
    var feeds = [Feed]()
    
    var  feedsViews = [UITableView]()
    var whispers = Dictionary<UITableView,[Whisper]>()
    
    var curScrollIndex = 0


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if feeds.count == 0 {
            print("prepareShow")
            prepareShow()
        }
    }
    
    func prepareShow(){
        let config = WhisperConfig.sharedInstance.config
        let feedJsons = config!["feeds"]
        let nib = UINib(nibName: "WhisperCell", bundle: nil)
        
        // init tableview inside scrollview
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        var index = 0
        for (_,feedJson):(String,SwiftyJSON.JSON) in feedJsons{
            let feed = Feed(json: feedJson)
            feeds.append(feed)
            let startX = (CGFloat(index) * width )
            let frame =  CGRectMake(  startX ,0,width - whisperScrollView.frame.origin.x,height)
            let View = UITableView(frame:frame,style:.Plain)
            View.headerViewForSection(0)
            View.registerClass(WhisperCell.self,forCellReuseIdentifier:"WhisperCell")
            View.registerNib(nib, forCellReuseIdentifier: "WhisperCell")
            whisperScrollView.addSubview(View)
            feedsViews.append(View)
            View.dataSource = self
            View.delegate = self
            View.estimatedRowHeight = View.rowHeight
            View.rowHeight = UITableViewAutomaticDimension
            View.separatorStyle = .None
            View.tableHeaderView = nil
            let refreshControl: UIRefreshControl = {
                let refreshControl = UIRefreshControl()
                refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
                
                return refreshControl
                }()
            View.addSubview(refreshControl)
            index += 1
            
        }
        
        let contentW: CGFloat = (CGFloat(feedJsons.array!.count) *  width )
        whisperScrollView.contentSize = CGSizeMake(contentW,0)
        whisperScrollView.pagingEnabled = true
        whisperScrollView.delegate  = self
    
        for view in topLabelScrollView.subviews{
            view.removeFromSuperview()
        }
        
        initData()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if topLabelScrollView.subviews.count < feeds.count{
            var index = 0
        for feed in feeds {
            
            let labelWidth = topLabelScrollView.frame.width / CGFloat(feeds.count )
            let labelFrame = CGRectMake((CGFloat(index) * labelWidth),topLabelScrollView.frame.origin.y,labelWidth,topLabelScrollView.frame.height)
            
            let label = UILabel(frame: labelFrame)

            print(feed.title)
            label.text = feed.title!
            label.textAlignment = NSTextAlignment.Center
            
            topLabelScrollView.addSubview(label)
            switch (index) {
            case 0 :
                setLabel(index,color: UIColor.purpleColor() ,fontSize: 12.0)
            default:
                setLabel(index,color: UIColor.grayColor() ,fontSize: 8.0)
            }
        
            
            index += 1
        }
        }
        super.viewDidAppear(animated)
    }
    
    func initData(){
        for i in 0...(feedsViews.count - 1){
            getWhisperData(i)
        }
    }
    
    //上拉刷新拉获取数据
    func handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        refreshControl.attributedTitle = NSAttributedString(string:"正在刷新。。")
        print("update fresh")
        getWhisperData(curScrollIndex)
        refreshControl.endRefreshing()
    }
    
    func getWhisperData(index:Int){
        print("get whisper data\(index)")
        var feedParams = Dictionary<String,AnyObject>()
        if( feeds[index].needLocation == true) {
            if let location = WhisperLocationControl.sharedInstance.location{
                feedParams = ["feed_id":feeds[index].id!, "type":feeds[index].type!,"limit":LIMIT,"uid":UID,"lat":location.coordinate.latitude,"lon": location.coordinate.longitude]
            }else{
                feedParams = ["feed_id":feeds[index].id!, "type":feeds[index].type!,"limit":LIMIT,"uid":UID,"lat":22.54911,"lon":113.942959]
            }
            
            print(WhisperLocationControl.sharedInstance.location?.coordinate.latitude, WhisperLocationControl.sharedInstance.location?.coordinate.longitude)
            
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
                let View = self.feedsViews[index]
                self.whispers[View] = whispersInIndex
                print("get data ok \(index)")
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
        return ( whisperScrollView.frame.size.height / 3)

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewWhispers = self.whispers[tableView]
        if tableViewWhispers != nil {
            return tableViewWhispers!.count
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewWhispers = self.whispers[tableView]
        let cell = tableView.dequeueReusableCellWithIdentifier("WhisperCell", forIndexPath: indexPath) as! WhisperCell
        if tableViewWhispers != nil   {
            cell.whisper = tableViewWhispers![indexPath.row]
        }
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let oldIndex = curScrollIndex
        setLabel(oldIndex, color: UIColor.grayColor(),fontSize: 8.0)

        updateCurScrollIndex(scrollView)
        setLabel(curScrollIndex, color: UIColor.purpleColor(),fontSize:12.0)

    }
    
    func setLabel(index:Int,color:UIColor,fontSize: CGFloat){
        let label = topLabelScrollView.subviews[index] as! UILabel
        UIView.transitionWithView(label, duration: 0.3, options: .TransitionCrossDissolve, animations: {
            label.textColor = color
            label.font = label.font.fontWithSize(fontSize)
            }, completion: nil)
    }
    
    func updateCurScrollIndex(scrollView: UIScrollView) -> Void {
        if scrollView.contentOffset.x > 0{
            let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
            curScrollIndex = index
        }
        
        if scrollView.contentOffset.y > 0{
            
        }
    }



}