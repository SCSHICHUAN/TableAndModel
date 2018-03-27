//
//  ViewController.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/3/26.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit

var heroModelArray:[HeroModel] = []


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func ddddd(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GETACtion()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //UITableViewDelegate
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroModelArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "heroCell")! as UITableViewCell
       
        let image    = cell.viewWithTag(101) as! UIImageView
        let name     = cell.viewWithTag(102) as! UILabel
        let bigName  = cell.viewWithTag(103) as! UILabel
        let smolName = cell.viewWithTag(104) as! UILabel
        let skill    = cell.viewWithTag(105) as! UILabel
        let skill2   = cell.viewWithTag(106) as! UILabel
        
        
        var model:HeroModel
        
        
        model = heroModelArray[indexPath.row] 
        name.text     = model.name
        bigName.text  = model.enName
        smolName.text = model.name2
        image.image   = model.headImage
        skill.text    = model.skill
        skill2.text   = model.skill2
        
        
        
        return cell
    }
   
    
    
    
    func GETACtion() {
        //请求URL
        let url:NSURL! = NSURL(string: "http://lol.qq.com/biz/hero/champion.js")
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
            
            // 获得编码ID
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
           
            var dogString:String = NSString(data: data!, encoding: enc)! as String
            
          //   print("str:\(dogString)")
            
            let range = dogString.index(dogString.endIndex, offsetBy: -43)..<dogString.endIndex
            let range2 = dogString.startIndex..<dogString.index(dogString.startIndex, offsetBy:2080)
            //去除一个范围内的str
            dogString.removeSubrange(range)
            dogString.removeSubrange(range2)
           // print("str2:\(dogString)")
            
            let testData = dogString.data(using: String.Encoding.utf8) // String转UTF8
    
           
            //转Json
            let jsonData:NSDictionary = try! JSONSerialization.jsonObject(with: testData!, options: .mutableContainers) as! NSDictionary
            
           

            // print(jsonData);
             let heroCount =  jsonData.count
    
            
            for nameHero in jsonData.allKeys {
                 let object = jsonData[nameHero] as! NSDictionary
                
                 let name  = object["name"] as! String
                 let id    = object["id"] as! String
                 let title = object["title"] as! String
                 let tags  = object["tags"] as! NSMutableArray
                
                var skill = ""
                var skill2 = ""
                
                
                if tags.count>1{
                    skill =  tags[0] as! String
                    skill2 = tags[1] as! String
                }else{
                    skill =  tags[0] as! String
                }
                
                print("name = \(name),id = \(id),title = \(title)")
                print("\(tags)")
                print("http://ossweb-img.qq.com/images/lol/img/champion/\(nameHero).png\n")
                
                
           
                let url = URL(string: "http://ossweb-img.qq.com/images/lol/img/champion/\(nameHero).png")
                let data1 = try? Data(contentsOf: url!)
                let image = UIImage(data:data1!)
                
                
                
                
                heroModelArray.append(HeroModel(name:title,name2:name,headImage:image!,enName:id,skill:skill,skill2:skill2))
               
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
            
            
             print("heroCount = \(heroCount)")
             print("heroModelArray = \(heroModelArray)")
           
            
        }
        
        //请求开始
        dataTask.resume()
        
    }
    
    
    func POSTACtion() {
        //请求URL
        let url:NSURL! = NSURL(string: "http://lol.qq.com/web201310/info-heros.shtml")
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        let list  = NSMutableArray()
        let paramDic = [String: String]()
        
        if paramDic.count > 0 {
            //设置为POST请求
            request.httpMethod = "POST"
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
            
            //            let str:String! = String(data: data!, encoding: NSUTF8StringEncoding)
            //            print("str:\(str)")
            //转Json
//            let jsonData:NSDictionary = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
//
//            print(jsonData)
           
        }
        //请求开始
        dataTask.resume()
    }
    
   
   
    
    
    
    
    
    
    
    
}
