//
//  HeroViewController.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/3/27.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit

class HeroViewController: UIViewController {
    var heroName:String!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var heroStory: UITextView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GETACtion3()
        // Do any additional setup after loading the view.
        print("heroName = \(heroName)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func GETACtion3() {
        //请求URL
        let url = URL (string:"http://lol.qq.com/biz/hero/\(heroName as String).js")
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url!)
        let list  = NSMutableArray()
        let paramDic = [String: String]()
        
        if paramDic.count > 0 {
            //设置为GET请求
            request.httpMethod = "GET"
            //拆分字典,subDic是其中一项，将key与value变成字符串
            for subDic in paramDic {
                let tmpStr = "\(subDic.0)=\(subDic.1)"
                list.add(tmpStr)
            }
            //用&拼接变成字符串的字典各项
            let paramStr = list.componentsJoined(by: "&")
            //UTF8转码，防止汉字符号引起的非法网址
            let paraData = paramStr.data(using: String.Encoding.utf8)
            //设置请求体
            request.httpBody = paraData
        }
        //默认session配置
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //发起请求
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // 获得编码ID
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            
            var dogString:String = NSString(data: data!, encoding: enc)! as String
            //            self.GETACtion2(herID: dogString)
            
           // print("dogString = \(dogString)")
            let offHead = self.heroName.count
            
            
            
                        let range = dogString.index(dogString.endIndex, offsetBy: -43)..<dogString.endIndex
                        let range2 = dogString.startIndex..<dogString.index(dogString.startIndex, offsetBy:70+offHead)
                        //去除一个范围内的str
                        dogString.removeSubrange(range)
                        dogString.removeSubrange(range2)
            // print("str2 = \(dogString)")
            
            let testData = dogString.data(using: String.Encoding.utf8) // String转UTF8
            //转Json
             let jsonData:NSDictionary = try! JSONSerialization.jsonObject(with: testData!, options: .mutableContainers) as! NSDictionary
            
            let heroStory = jsonData["blurb"] as!String
            let skins = jsonData["skins"] as!NSArray
            let skin = skins[0] as!NSDictionary
            let skinID = skin["id"] as! String
            
            let url = URL(string: "http://ossweb-img.qq.com/images/lol/web201310/skin/big\(skinID).jpg")
            let data1 = try? Data(contentsOf: url!)
            let image = UIImage(data:data1!)
            
            
            DispatchQueue.main.async(execute: {
                self.imageView1.image = image
                self.heroStory.text = heroStory
            })
            
            
            print(heroStory);
            
            
        }
        
        //请求开始
        dataTask.resume()
        
    }
    
}
