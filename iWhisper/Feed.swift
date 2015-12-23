//
//  Feed.swift
//  iWhisper
//
//  Created by swift on 15/12/23.
//  Copyright © 2015年 chensb. All rights reserved.
//

import SwiftyJSON

class Feed{
    
    init(json :SwiftyJSON.JSON){
        self.id = json["id"].string!
        self.title = json["title"].string!
        self.type = json["type"].string!
        self.needLocation = json["need_location"].bool!
    }
    
    let  id : String?
    let  title: String?
    let type: String?
    let needLocation: Bool?
    
}