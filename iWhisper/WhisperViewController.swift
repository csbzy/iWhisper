//
//  ViewController.swift
//  iWhisper
//
//  Created by swift on 15/12/22.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON
import Alamofire

class WhisperViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {
    
    @IBOutlet weak var whisperScrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topLabelScrollView: UIScrollView!
    @IBOutlet weak var personInfoButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    
    var feeds = [Feed]()
    
    var  feedsViews = [UITableView]()
    var whispers = Dictionary<UITableView,[Whisper]>()
    
    var curScrollIndex = 0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let frame =  CGRectMake(  startX ,-20,width - whisperScrollView.frame.origin.x,height)
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
            index += 1
        }
        
        let contentW: CGFloat = (CGFloat(feedJsons.array!.count) *  width )
        whisperScrollView.contentSize = CGSizeMake(contentW,0)
        whisperScrollView.pagingEnabled = true
        whisperScrollView.delegate  = self
        
        
        initData()
        
        for view in topLabelScrollView.subviews{
            view.removeFromSuperview()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()

    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.requestLocation()
        print("update location error\(error)")
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last!
        
        print("didUpdateLocations:  \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            print(".NotDetermined;")
            break
            
        case .Authorized:
            print(".Authorized")
            locationManager.startUpdatingLocation()
            break
            
        case .Denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    override func viewDidAppear(animated: Bool) {
        var index = 0
        for feed in feeds {
            
            let labelWidth = topLabelScrollView.frame.width / CGFloat(feeds.count )
            let labelFrame = CGRectMake((CGFloat(index) * labelWidth),topLabelScrollView.frame.origin.y,labelWidth,topLabelScrollView.frame.height)
            
            let label = UILabel(frame: labelFrame)

            print(feed.title)
            label.text = feed.title!
            label.textAlignment = NSTextAlignment.Center
            switch (index) {
            case 0 :
                label.textColor = UIColor.purpleColor()
            default:
                label.textColor = UIColor.grayColor()
            }
        
            topLabelScrollView.addSubview(label)
            index += 1
        }
        super.viewDidAppear(animated)
    }
    
    func initData(){
        for i in 0...(feedsViews.count - 1){
            getWhisperData(i)
        }
    }
    
    
    func getWhisperData(index:Int){
        print("get whisper data\(index)")
        var feedParams = Dictionary<String,AnyObject>()
        if( feeds[index].needLocation == true) {
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
        setLabelColor(oldIndex, color: UIColor.grayColor())

        updateCurScrollIndex(scrollView)
        setLabelColor(curScrollIndex, color: UIColor.purpleColor())

    }
    
    func setLabelColor(index:Int,color:UIColor){
        let label = topLabelScrollView.subviews[index] as! UILabel
        UIView.transitionWithView(label, duration: 0.3, options: .TransitionCrossDissolve, animations: { label.textColor = color }, completion: nil)
    }
    func updateCurScrollIndex(scrollView: UIScrollView) -> Int {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        curScrollIndex = index
        return index
    }



}