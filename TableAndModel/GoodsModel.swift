//
//  GoodsModel.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/4/12.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit

class GoodsModel: NSObject {
    
    var name:String
    var description1:String
    var headImage:UIImage
    var images:Array<String>
   
    
    init(name:String,description1:String,headImage:UIImage,images:Array<String>) {
        self.name = name
        self.description1 = description1
        self.headImage = headImage
        self.images = images
    }

}
