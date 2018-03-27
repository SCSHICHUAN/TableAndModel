//
//  HeroModel.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/3/27.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit

class HeroModel: NSObject {
    
    var name:String
    var name2:String
    var headImage:UIImage
    var enName:String
    var skill:String
    var skill2:String
    
    init(name:String,name2:String,headImage:UIImage,enName:String,skill:String,skill2:String) {
        self.name = name
        self.name2 = name2
        self.headImage = headImage
        self.enName = enName
        self.skill = skill
        self.skill2 = skill2
    }

}
