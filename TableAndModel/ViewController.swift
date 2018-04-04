//
//  ViewController.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/3/26.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit

var heroModelArray:[HeroModel] = []
var heroIDDict:NSMutableDictionary = [:]
var heroSerchArry:[HeroModel] = []
let herVC:HeroViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"123456") as! HeroViewController


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
     var searchBarStatu = 0
    
   
    //UISearchBarDelegate
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
     
        print(searchText)
        
       heroSerchArry = heroModelArray.filter({ (heroModel:HeroModel) -> Bool in
      
        if heroModel.name.range(of: searchText) != nil {
            return true
        }else{
            if heroModel.name2.range(of: searchText) != nil{
                return true
            }
            return false
        }
        
        })
    
    }
   
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
         searchBarStatu = 1
        tableView.reloadData()
        return true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
         searchBarStatu = 0
        self.tableView.reloadData()
    }
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
        
       
        
    }
   
   

    
    @IBAction func serchSrar(_ sender: UIBarButtonItem) {
      searchBar.becomeFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        // item.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = item
        
        //修改导航栏背景色
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1)
        //修改导航栏文字颜色
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        //修改导航栏按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //        self.navigationController?.navigationBar
        //            .setBackgroundImage(UIImage(named: "bg5"), for: .default)
        
        tableView.contentOffset = CGPoint(x: 0, y: 60)
        searchBar.frame.origin.y = 64
       GETACtion()
       
        
         
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //UITableViewDelegate
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if  searchBarStatu == 1 {
            return heroSerchArry.count
        }else{
            return heroModelArray.count
       }

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
        
        if  searchBarStatu == 1 {
            model = heroSerchArry[indexPath.row]
        }else{
            model = heroModelArray[indexPath.row]
        }
        
        
        name.text     = model.name
        bigName.text  = model.enName
        smolName.text = model.name2
        image.image   = model.headImage
        skill.text    = model.skill
        skill2.text   = model.skill2
        
      
        
        return cell
    }
   
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
       
        
        var indexPath = tableView.indexPathForSelectedRow
        let inn = indexPath?.row
        print("inn = \(String(describing: inn))")
        var name = ""

        if tableView.tag == 101 {
            name = (heroModelArray[(indexPath?.row)!] as HeroModel).enName
        }else{
             name = (heroSerchArry[(indexPath?.row)!] as HeroModel).enName
            }
        
        //  print("heroName==\(name)")
        herVC.heroName = name
        
         herVC.hidesBottomBarWhenPushed = true
         self.navigationController?.pushViewController(herVC, animated: true)
        
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    

//    // Segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "1000" {
//
//            herVC = segue.destination as! HeroViewController
//            }
//    }
    

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
            
            let error = String(describing: error)
            if error != "nil" {
                return
            }
            
            // 获得编码ID
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
           
            var dogString:String = NSString(data: data!, encoding: enc)! as String
            self.GETACtion2(herID: dogString)
            
            // print("str:\(dogString)")
            
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
                
//                print("name = \(name),id = \(id),title = \(title)")
//                print("\(tags)")
//                print("http://ossweb-img.qq.com/images/lol/img/champion/\(nameHero).png\n")
                
                
           
                let url = URL(string: "http://ossweb-img.qq.com/images/lol/img/champion/\(nameHero).png")
                let data1 = try? Data(contentsOf: url!)
                let image = UIImage(data:data1!)
                
                
                
                
                heroModelArray.append(HeroModel(name:title,name2:name,headImage:image!,enName:id,skill:skill,skill2:skill2))
               
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
            
            
            
           
            
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
    
   
   
    func GETACtion2(herID:String) {
        
        
        var dogString = herID
        let range = dogString.index(dogString.endIndex, offsetBy: -31737)..<dogString.endIndex
            let range2 = dogString.startIndex..<dogString.index(dogString.startIndex, offsetBy:58)
            //去除一个范围内的str
            
            dogString.removeSubrange(range)
            dogString.removeSubrange(range2)
            
          
            
           // print("herID= \(dogString)")
        
        let testData = dogString.data(using: String.Encoding.utf8) // String转UTF8
        //转Json
        let jsonData:NSDictionary = try! JSONSerialization.jsonObject(with: testData!, options: .mutableContainers) as! NSDictionary
        

         //    print(jsonData);

        //let heroID = jsonData["1"] as!String
       // print("herID = \(heroID)")
          
        for heroName in jsonData.allKeys{
            heroIDDict.setValue(heroName as! String,forKey:jsonData[heroName] as! String)
        }
            
        let heroID = heroIDDict["Lucian"] as!String
        let sikeUrl = "http://ossweb-img.qq.com/images/lol/web201310/skin/big\(heroID)000.jpg"
        
        print("sikeUrl = \(sikeUrl)")
      
        
    }
    
    
    
    func POSTACtion3() {
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
