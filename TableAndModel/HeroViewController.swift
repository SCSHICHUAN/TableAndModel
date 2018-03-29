//
//  HeroViewController.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/3/27.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit
//let LogonSB   = UIStoryboard.init(name: "Logon", bundle: Bundle.main)
//var vcc = LogonSB.instantiateViewController(withIdentifier: "OverSeaNavi")

let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height
var offSetCont:CGFloat!


class HeroViewController: UIViewController,UIScrollViewDelegate {
    var heroName:String!
    var scroTime:Timer!
   
    
    
    lazy var buttom:UIButton = {
        let _buttom = UIButton(frame:CGRect(x:10, y:150, width:100, height:30))
            _buttom.backgroundColor = UIColor.green
            _buttom.addTarget(self, action:#selector(button), for:.touchUpInside)
        return _buttom
    }()
    lazy var scrovView:UIScrollView = {
        
        let _scrovView = UIScrollView(frame:CGRect(x:0,y:0,width:screenW,height:screenH))
        _scrovView.contentSize = CGSize(width:screenW,height:2*screenH)
        return _scrovView
    }()
    
    lazy var skinScroView:UIScrollView = {
         let _skinScroview = UIScrollView(frame:CGRect(x:0,y:0,width:screenW,height:screenW*(9/16)))
        _skinScroview.isPagingEnabled = true
        _skinScroview.tag = 1011
        return _skinScroview
    }()
    
    lazy var imageView1:UIImageView = {
        
        let _imageView1 = UIImageView(frame:CGRect(x:5, y:5, width:screenW-10, height:screenW*(9/16)-5))
        return _imageView1
    }()
   
   
    lazy var heroStory:UITextView = {
        let _textView = UITextView(frame:CGRect(x:10, y:imageView1.frame.maxY, width:screenW-20, height:screenW*(9/16)))
        return _textView
        
    }()
    
   
    
    

    func timeStar(){
        scroTime =  Timer.scheduledTimer(timeInterval: 3,target: self,selector: #selector(timeSelector), userInfo:nil, repeats:true)
    }
    
   
    
    
   

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       skinScroView.delegate = self
      
    
     
     
       
     
        GETACtion3()
      

        self.view.addSubview(scrovView)
        scrovView.addSubview(skinScroView)
       // scrovView.addSubview(buttom)
        scrovView.addSubview(heroStory)

        timeStar()
    
    }

    var currentOff = 0
    @objc func timeSelector(){
   
    self.skinScroView.setContentOffset(CGPoint(x:screenW*CGFloat(self.currentOff) ,y:0), animated: true)
       
         currentOff+=1
        if CGFloat(self.currentOff) == offSetCont {
            currentOff = 0
        }
    }
    
    //UIScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        if scrollView.tag == 1011 {
            scroTime.invalidate()
        }
        
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if scrollView.tag == 1011 {
            timeStar()
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let offSet =  skinScroView.contentOffset
        currentOff  = Int(offSet.x/screenW)
    }
    
    
    
    
    @objc func button() {
        print("sss")
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
            
//            print("dogString = \(dogString)")
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
            
          
            
            
            
            DispatchQueue.main.async(execute: {
                self.skinScroView.contentSize = CGSize(width:screenW+screenW*CGFloat(skins.count-1),height:screenW*(9/16))
                offSetCont = CGFloat(skins.count)
            })
                var idCount:CGFloat = 0
                let queue = DispatchQueue(label:"download")
            
            
                    
                for skinItem in skins {
                    
                    queue.async{
                        let skinID = (skinItem as! NSDictionary)["id"] as! String
                        let url = URL(string: "http://ossweb-img.qq.com/images/lol/web201310/skin/big\(skinID).jpg")
                        let  data1 = try? Data(contentsOf: url!)
                        let  image = UIImage(data:data1!)
                        
                         print("current thread name is:\(Thread.current)")
            
                        DispatchQueue.main.sync(execute: {//同步
                            
                            print("skinID = \(skinID)")
                            
                            let _imageView1 = UIImageView(frame:CGRect(x:screenW*idCount+5, y:5, width:screenW-10, height:screenW*(9/16)-10))
                            _imageView1.image = image
                            self.skinScroView.addSubview(_imageView1)
                        
                        })
                        idCount+=1
                    }
                    
 
                    
            }
            
         
            
          //  http://ossweb-img.qq.com/images/lol/img/passive/Malphite_GraniteShield.png
            
                
            
            
            print(heroStory);
            
            
        }
        
        //请求开始
        dataTask.resume()
        
    }
    
}
