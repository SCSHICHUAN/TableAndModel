//
//  GoodsViewController.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/4/4.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit

var goodsArry = [GoodsModel]()
var goodsDict = [String:UIImage]()
var goodsJSON:NSDictionary!

class GoodsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    @IBOutlet weak var collectionView: UICollectionView!
    var vc:GoodsItemViewController!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //修改导航栏背景色
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1)
        //修改导航栏文字颜色
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        //修改导航栏按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
       GETACtion()
    }

    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return goodsArry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "goodsCell", for: indexPath) as UICollectionViewCell
        let image    = cell.viewWithTag(120) as! UIImageView
        let name     = cell.viewWithTag(121) as! UILabel
        
        let model = goodsArry[indexPath.item]
        image.image = model.headImage
        name.text = model.name
        
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/4-2, height: UIScreen.main.bounds.size.width/4-2+20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let model = goodsArry[indexPath.item]
        
         vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"1112") as! GoodsItemViewController
       
         vc.hidesBottomBarWhenPushed = true
         vc.name = model.name
         vc.image = model.headImage
         vc.images = model.images
         vc.goodsDict = goodsDict
         vc.goodsJSON = goodsJSON
         vc.descriptionStr = model.description1
         vc.view.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
       
        let button = UIButton(frame: UIScreen.main.bounds)
        vc.view .addSubview(button)
        button .addTarget(self, action:#selector(button2), for:.touchUpInside)
        
        
        
         self.view  .addSubview(vc.view)
        //self.navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func button2(){
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        vc.view .removeFromSuperview()
       
    }
    
    
    func GETACtion() {
        //请求URL
        let url:NSURL! = NSURL(string: "http://lol.qq.com/biz/hero/item.js")
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
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
            
            let error = String(describing: error)
            if error != "nil" {
                return
            }
            
            // 获得编码ID
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            
            var dogString:String = NSString(data: data!, encoding: enc)! as String
            //self.GETACtion2(herID: dogString)
            
           // print("str:\(dogString)")
            
            let range = dogString.index(dogString.endIndex, offsetBy: -1)..<dogString.endIndex
            let range2 = dogString.startIndex..<dogString.index(dogString.startIndex, offsetBy:28)//头
            //去除一个范围内的str
            dogString.removeSubrange(range)
            dogString.removeSubrange(range2)
            // print("str2:\(dogString)")
            
            let testData = dogString.data(using: String.Encoding.utf8) // String转UTF8
            //转Json
            let jsonData:NSDictionary = try! JSONSerialization.jsonObject(with: testData!, options: .mutableContainers) as! NSDictionary
            
             let goods = jsonData["data"] as!NSDictionary
             goodsJSON = jsonData["data"] as!NSDictionary
           //  print(goods);
            
            
            
            for goods1 in goods.allKeys {
            
                let object = goods[goods1] as! NSDictionary

                let name  = object["name"] as! String
                let description = object["description"] as! String
                let imageDict = object["image"] as! NSDictionary
                let full = imageDict["full"] as!String
                
                var images = [String]()
                for key111 in object.allKeys {
                    if (key111 as! String) == "from"{
                        images = object["from"] as! Array<String>
                    }
    
                }
                
                
                

                let url = URL(string: "http://ossweb-img.qq.com/images/lol/img/item/\(full)")
                let data1 = try? Data(contentsOf: url!)
                var image = UIImage(named:"small_axe")
                
                if data1 == nil{
                }else{
                     image = UIImage(data:data1!)
                }
                
                goodsDict.updateValue(image!, forKey: goods1 as! String)
                goodsArry.append(GoodsModel(name: name, description1: description, headImage: image!,images: images))

                
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
            }
            
            
        }
        
        //请求开始
        dataTask.resume()
        
    }
    

}
