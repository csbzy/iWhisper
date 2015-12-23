//
//  WhisperConfig.swift
//  iWhisper
//
//  Created by swift on 15/12/22.
//  Copyright © 2015年 chensb. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WhisperConfig {
    
    var config : SwiftyJSON.JSON?
    class var sharedInstance: WhisperConfig {
        struct Singleton{
            static let instance = WhisperConfig()
        }
        return Singleton.instance
    }
    
    func getConfigOnline( callback : () -> Void){
            print("get config online")
        Alamofire.request(.GET, SPLASH_HTML_URL,parameters:["type":"ios","uid": UID])
                .responseJSON { response in
                    let json = SwiftyJSON.JSON(response.result.value!)
                    //print("JSON\(json)")
                    self.config = json
                    callback()
//                    let defaultNSUser = NSUserDefaults.standardUserDefaults()
//                    defaultNSUser.setObject( json, forKey: "config")
            }
    }
    
//    class func loadConfig(callback : ()-> Void )->WhisperConfig{
////        let defaultNSUser = NSUserDefaults.standardUserDefaults()
////        if let config = defaultNSUser.objectForKey("config") as? SwiftyJSON.JSON{
////            return WhisperConfig(config: config)
////        }else{
////            return WhisperConfig()
////        }
//        let instance = WhisperConfig()
//        instance.getConfigOnline( callback )
//        return instance
//    }
}