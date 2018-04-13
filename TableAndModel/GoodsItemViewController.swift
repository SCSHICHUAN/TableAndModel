//
//  GoodsItemViewController.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/4/13.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit

class GoodsItemViewController: UIViewController {
    var name:String!
    var image:UIImage!
    var images:Array<UIImage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = name
        let imageV    = self.view.viewWithTag(115) as! UIImageView
        imageV.image = image
        let morge  = (UIScreen.main.bounds.width/CGFloat(images.count))
        
        if images.count>0 {
            for i in 1...images.count{
                print(i)
                let imageView = UIImageView(frame: CGRect(x:CGFloat(i-1)*morge + morge/2-40/2, y: 200, width: 40, height: 40))
                imageView.image = images[i-1]
                self.view .addSubview(imageView)
            }
        }
   
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
