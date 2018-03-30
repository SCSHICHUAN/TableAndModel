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
    var textViewOld:UILabel = UILabel()
    

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
   
   
    lazy var heroStory:UILabel = {
        let _textView = UILabel(frame:CGRect(x:10, y:imageView1.frame.maxY+20, width:screenW-20, height:0))
        _textView.font = UIFont.systemFont(ofSize: 15)
        _textView.numberOfLines = 0
        _textView.textAlignment = NSTextAlignment.left
//        _textView.backgroundColor = UIColor(white:0,alpha:0.1)
        _textView.isUserInteractionEnabled = false
        return _textView
        
    }()
    lazy var pageControl:UIPageControl = {
        let _pageControl = UIPageControl(frame:CGRect(x:0, y:skinScroView.frame.maxY-30, width:screenW,height:20))
        _pageControl.numberOfPages = 1
        _pageControl.pageIndicatorTintColor = UIColor.darkGray
        _pageControl.currentPageIndicatorTintColor = UIColor.white
        _pageControl.addTarget(self, action:#selector(pageChange), for:.valueChanged)
        return _pageControl
    }()
   
    

    func timeStar(){
        scroTime =  Timer.scheduledTimer(timeInterval: 3,target: self,selector: #selector(timeSelector), userInfo:nil, repeats:true)
    }
    
   
    @objc func pageChange(page: UIPageControl) {
         let  x = page.currentPage * Int(screenW)
        self.skinScroView.setContentOffset(CGPoint(x:x,y:0), animated: true)
    }
    
    

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      
    
     skinScroView.delegate = self
    
       
     
        GET_http_char()
      

        self.view.addSubview(scrovView)
        scrovView.addSubview(skinScroView)
       // scrovView.addSubview(buttom)
        scrovView.addSubview(heroStory)
        scrovView.addSubview(pageControl)

        timeStar()
    
    }

    var currentOff = 0
    @objc func timeSelector(){
   
    self.skinScroView.setContentOffset(CGPoint(x:screenW*CGFloat(self.currentOff) ,y:0), animated: true)
        pageControl.numberOfPages = Int(offSetCont)
        pageControl.currentPage = currentOff;
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
        pageControl.currentPage = currentOff
    }
    
    
    
    
    @objc func button() {
        print("sss")
    }
    
    
    
    
    
    func headView(jsonData: NSDictionary){
      
        let storyStr = jsonData["blurb"] as!String
        let heroStory = "        " + storyStr
        let skins = jsonData["skins"] as!NSArray
        let heroName = jsonData["name"] as!String
        self.title = heroName
        
        
        DispatchQueue.main.async(execute: {
            self.skinScroView.contentSize = CGSize(width:screenW+screenW*CGFloat(skins.count-1),height:screenW*(9/16))
            offSetCont = CGFloat(skins.count)
        
            self.heroStory.frame.size.height = self.textHeight(text: heroStory,font: UIFont.systemFont(ofSize: 15), widthMax: screenW - 20)
            self.heroStory.text = heroStory
            
        })
        var idCount:CGFloat = 0
        let queue = DispatchQueue(label:"download")
        //  let queue  = DispatchQueue.global() //异步
        
        
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
                    
                    let nameLeble:UILabel = UILabel(frame:CGRect(x:5,y:10,width:screenW,height:10))
                    nameLeble.textColor = UIColor.white
                    if #available(iOS 8.2, *) {
                        nameLeble.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 5))
                    } else {
                        // Fallback on earlier versions
                    }
                    nameLeble.textAlignment = NSTextAlignment.left
                    nameLeble.layer.shadowColor = UIColor.black.cgColor
                    nameLeble.layer.shadowOffset = CGSize(width:0,height:0)
                    nameLeble.layer.shadowOpacity = 0.5
                    nameLeble.text = (skinItem as! NSDictionary)["name"] as? String
                    if nameLeble.text == "default" {
                        nameLeble.text = heroName
                    }
                    
                    
                    self.skinScroView.addSubview(_imageView1)
                    _imageView1 .addSubview(nameLeble)
                    
                })
                idCount+=1
            }
            
        }
        
        
        //  http://ossweb-img.qq.com/images/lol/img/passive/Malphite_GraniteShield.png
        //  http://ossweb-img.qq.com/images/lol/img/passive/Ashe_P.png
        
        print(heroStory);
        
    }
    
    func spells(jsonData: NSDictionary){
        let spells = jsonData["spells"] as!NSArray
       
        
        
         var  first:CGFloat = 1
        for i in 0...spells.count-1 {
            
            let dict = spells[i] as!NSDictionary
            let id = dict["id"] as!String
            let name = dict["name"] as!String
            let description = dict["description"] as!String
            let image = dict["image"] as!NSDictionary
                let full = image["full"] as!String
                let sprite = image["sprite"] as!String
                let group  = image["group"] as!String
            let tooltip = dict["tooltip"] as!String
            
            
            
          
            
           
            let queue = DispatchQueue(label:"download")
            
            queue.sync{
                    let url = URL(string: "http://ossweb-img.qq.com/images/lol/img/spell/\(full)")
                    let  data1 = try? Data(contentsOf: url!)
                    let  image = UIImage(data:data1!)
                
                
                    DispatchQueue.main.sync(execute: {
                        
                        let imageView = UIImageView(
                        frame:CGRect(x:10,
                                     y:(self.heroStory.frame.maxY+20)*first + self.textViewOld.frame.maxY + 25,
                                 width:48,
                                height:48))
                        imageView.image = image
                        let H = self.textHeight(text: description, font: UIFont.systemFont(ofSize: 15), widthMax: screenW-20)
                        let textView = UILabel(frame:CGRect(x:10,y:imageView.frame.maxY+10,width:screenW-20,height:H))
                        let textView2 = UILabel(frame:CGRect(x:65,y:imageView.frame.maxY-15,width:screenW-20,height:15))
                        let textView3 = UILabel(frame:CGRect(x:65,y:imageView.frame.minY,width:screenW-20,height:16))
                        self.textViewOld = textView
                        textView.numberOfLines = 0
                        textView.textAlignment = NSTextAlignment.left
                        textView.font = UIFont.systemFont(ofSize: 15)
                        first = 0
//                        textView2.backgroundColor  = UIColor.lightGray
//                        textView.backgroundColor  = UIColor.gray
                        if #available(iOS 8.2, *) {
                            textView2.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 5))
                            textView3.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 5))
                        } else {
                            // Fallback on earlier versions
                        }
                        textView.text = description
                        textView2.text = name
                     
                        if i == 0 {
                            textView3.text = "Q"
                        }else if i == 1 {
                            textView3.text = "W"
                        }else if i == 2 {
                            textView3.text = "E"
                        }else if i == 3 {
                            textView3.text = "R"
                        }
                        
                        self.scrovView.addSubview(imageView)
                        self.scrovView.addSubview(textView)
                        self.scrovView.addSubview(textView2)
                        self.scrovView.addSubview(textView3)
                    })
                  
            
        }
                    
            
            
            
        
        }
        
        
        
    }
    
    
    
    //计算文字的高度
    func textHeight(text:String,font:UIFont,widthMax:CGFloat)->CGFloat{
        return (text.boundingRect(with: CGSize(width:widthMax,height:CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size).height
    }
    
    func GET_http_char() {
        //请求URL
        let url = URL (string:"http://lol.qq.com/biz/hero/\(heroName as String).js")
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url!)
    
        //默认session配置
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //发起请求
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
           
            let error = String(describing: error)            
            if error == "nil" {
                // 获得编码ID GB_18030_2000编码
                let encodingName = CFStringConvertEncodingToNSStringEncoding(
                    CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
                var dataString:String = NSString(data: data!, encoding: encodingName)! as String
                print("dataString = \(dataString)")
                
                //截取JSON str
                let offHead = self.heroName.count
                let range = dataString.index(dataString.endIndex, offsetBy: -43)..<dataString.endIndex
                let range2 = dataString.startIndex..<dataString.index(dataString.startIndex, offsetBy:70+offHead)
                //去除一个范围内的str
                dataString.removeSubrange(range)
                dataString.removeSubrange(range2)
                
                //转Json
                let testData = dataString.data(using: String.Encoding.utf8)
                let jsonData:NSDictionary =
                    try! JSONSerialization.jsonObject(with: testData!, options: .mutableContainers) as! NSDictionary
                self.headView(jsonData: jsonData)
                self.spells(jsonData: jsonData)
                
            }else{
                print("error = \(String(describing: error))")
            }
        }
        //请求开始
        dataTask.resume()
    }
    
    
    
}
