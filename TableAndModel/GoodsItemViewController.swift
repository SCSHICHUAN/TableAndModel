//
//  GoodsItemViewController.swift
//  TableAndModel
//
//  Created by SHICHUAN on 2018/4/13.
//  Copyright © 2018年 SHICHUAN. All rights reserved.
//

import UIKit

struct rectSC {
    var layer:String!
    var rect:CGRect!
}



class GoodsItemViewController: UIViewController {
    var name:String!
    var image:UIImage!
    var goodsDict:Dictionary<String,UIImage>!
    var images:Array<String>!
    var goodsJSON:NSDictionary!
    var imagesLine =  [rectSC]()
    var imagesLine1 = [rectSC]()
    var imagesLine2 = [rectSC]()
    var imagesLineAll = [[rectSC]()]
    var descriptionStr:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        // Do any additional setup after loading the view.
        self.title = name
        let imageV    = self.view.viewWithTag(115) as! UIImageView
        imageV.image = image
        let morge  = (UIScreen.main.bounds.width/CGFloat(images.count))
       
        let leable = UILabel(frame: CGRect(x: 10, y: 300, width:UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.width))
        leable.numberOfLines = 0
        leable.text =  cutOutText(allStr: descriptionStr, starStr: "<", endStr: ">")
        leable.textColor = UIColor(red: 128.0/255.0, green: 215.0/255.0, blue: 64.0/255.0, alpha: 1)
        
        
        self.view .addSubview(leable)
        do{
            let leable = UILabel(frame: CGRect(x:0, y: 40, width:UIScreen.main.bounds.width, height: 22))
            leable.text = name
            leable.textAlignment = NSTextAlignment.center
            leable.textColor = UIColor(red: 128.0/255.0, green: 215.0/255.0, blue: 64.0/255.0, alpha: 1)
            if #available(iOS 8.2, *) {
                leable.font = UIFont.systemFont(ofSize: 17, weight: .init(1.5))
            } else {
                // Fallback on earlier versions
            }
            self.view .addSubview(leable)
        }
       
        
        
        if images.count>0 {
            //第二层 装备
            for firstLayer in 1...images.count{
                let rect0 = CGRect(x:CGFloat(firstLayer-1)*morge + morge/2-40/2, y: 200, width: 40, height: 40)
                let imageView = UIImageView(frame:rect0)
                let rectStu = rectSC(layer: "0", rect: rect0)
                imagesLine.append(rectStu)
                imageView.image = goodsDict[images[firstLayer-1]]
                print("imageKeyStr = \(firstLayer)=\(images[firstLayer-1])")
                self.view .addSubview(imageView)
                
              // 看有没有准备合成
              let object = goodsJSON[images[firstLayer-1]] as! NSDictionary
               
                //第三层 装备
               var images2 = [String]()
                for key111 in object.allKeys {
                    if (key111 as! String) == "from"{
                    
                        images2 = object["from"] as! Array<String>
                         let morge2 =  morge/CGFloat(images2.count)//获取合成的数量
                      
                        if images2.count>0 {
                            
                                for secondLayer in 1...images2.count{
                                    //注意layer的添加
                                    let rect1 = CGRect(x:morge*CGFloat(firstLayer-1)+CGFloat(secondLayer-1)*morge2+morge2/2-40/2, y: 280, width: 40, height: 40)
                                    let imageView = UIImageView(frame:rect1)
                                    imageView.image = goodsDict[images2[secondLayer-1]]
                                    self.view .addSubview(imageView)
                                    let rectstu1 = rectSC(layer: "\(firstLayer)", rect: rect1)
                                    imagesLine1.append(rectstu1)
                                    
                                    
                                    //第四层 装备
                                    var images3 = [String]()
                                    let object = goodsJSON[images2[secondLayer-1]] as! NSDictionary
                                    for key111 in object.allKeys {
                                        if (key111 as! String) == "from"{
                                            images3 = object["from"] as! Array<String>
                                            let morge3 =  morge2/CGFloat(images3.count)
                                            
                                            for thirtLayer in 1...images3.count{
                                                 let rect3 = CGRect(x:morge*CGFloat(firstLayer-1)+morge2*CGFloat(secondLayer-1)+CGFloat(thirtLayer-1)*morge3 + morge3/2-40/2, y: 360, width: 40, height: 40)
                                                //                                                         第一层                       第二层                   第三层
                                                let imageView = UIImageView(frame: rect3)
                                                imageView.image = goodsDict[images3[thirtLayer-1]]
                                                self.view .addSubview(imageView)
                                                let stu = rectSC(layer: "\(secondLayer)", rect: rect3)
                                                
                                                imagesLine2.append(stu)
                                            }
                                            
                                        }else{
                                            images3.append("N")
                                        }
                                        
                                    }
                                    
                                }
                        }
                        
                        
                    }else{
                        images2.append("N")
                    }
                    
                   
                }
  
            }
        }
    
          if imagesLine.count>0{imagesLineAll.append(imagesLine)}
          if imagesLine1.count>0{imagesLineAll.append(imagesLine1)}
          if imagesLine2.count>0{imagesLineAll.append(imagesLine2)}
        
     //  print("dddd = \(imagesLine.count)")
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let cgView = CGView(frame: frame,lineRect:imagesLineAll)
        self.view.addSubview(cgView)
    
    }

    
    func cutOutText(allStr:String,starStr:String,endStr:String)->String{
        
        //原理说明，把需要截取的字符串添加在一起，不要在原有的基础上截取，如果在原有的字符串截取，由于index是
        //变换的代码不好实现，
        //  oldStr = “11111111111111111111111111” 以三个字符串的大小为例子
        //    查找过程 “***11111111111111111111111”
        //    查找过程 “1***1111111111111111111111”
        //    查找过程 “11***111111111111111111111”
        //    查找过程 “111***11111111111111111111”
        //    查找过程 “1111***1111111111111111111”
        //    查找过程 “11111***111111111111111111”
        //    查找过程 “111111***11111111111111111”
        //    查找过程 “1111111***1111111111111111”
        //    查找过程 “11111111***111111111111111”
        //    查找过程 “111111111***11111111111111”
        //    查找过程 “1111111111***1111111111111” 如果在这里找到了
        //如果发现有和这三个字符串相同的字符串 ，就把这三个字符串后的字符串加起来然后返回，这样就实现了截取***后的字符串
        
        
        
        var find = false
        var finally = ""
        var finally2 = ""
        
        if starStr.count >  allStr.count {
            return ""
        }
        
        for i in 0...allStr.endIndex.encodedOffset - starStr.endIndex.encodedOffset {
            
            //截取开始的字符串
            let startIndex = allStr.index(allStr.startIndex, offsetBy:i)
            let endIndex =  allStr.index(startIndex, offsetBy:starStr.endIndex.encodedOffset)
            let result =    allStr[startIndex..<endIndex]
            
            //截取结尾的字符串
            let startIndex2 = allStr.index(allStr.startIndex, offsetBy:i)
            let endIndex2 =  allStr.index(startIndex2, offsetBy:endStr.endIndex.encodedOffset)
            let result2 =    allStr[startIndex2..<endIndex2]
            
            
            //如果发现头str相同
            if result == starStr {
                find = true
            }
            
            if find {
                finally2 += result2 //字符串相加
            }else{
                finally  += result2
            }
            
            
            if result2 == endStr {
                find = false
            }
            
        }
        
        print("finally2 = \(finally2)")
        return finally
    }
    
    
    
}


class CGView:UIView {
    
     var imagesLineAll = [[rectSC]()]
    
    
    init(frame: CGRect,lineRect:Array<[rectSC]>) {
        super.init(frame: frame)
        //设置背景色为透明，否则是黑色背景
        self.backgroundColor = UIColor.clear
        imagesLineAll = lineRect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
      
        if imagesLineAll.count>1 {
        context.move(to: CGPoint(x: UIScreen.main.bounds.width/2, y: 154))
        context.addLine(to: CGPoint(x:UIScreen.main.bounds.width/2, y: 180))
        }
        
        if imagesLineAll.count>1 {
          
            
            
            let x =   (imagesLineAll[1].first?.rect.origin.x)!+19
            let x2 =   (imagesLineAll[1].last?.rect.origin.x)!+21

            context.move(to: CGPoint(x: x, y: 180))
            context.addLine(to: CGPoint(x: x2, y: 180))

            let rectArry = imagesLineAll[1]

            for rect in rectArry{
                let rect = rect.rect!

                //竖线
                context.move(to: CGPoint(x:rect.origin.x+20, y: rect.origin.y))
                context.addLine(to: CGPoint(x:rect.origin.x+20, y: rect.origin.y-20))

            }

            if imagesLineAll.count>2 {

                 let rectArry = imagesLineAll[2]


                
                var array11 = [rectSC]()
                var array12 = [rectSC]()
                var array13 = [rectSC]()
                for rect in rectArry{
                    //竖线
                    context.move(to: CGPoint(x:rect.rect.origin.x+20, y: rect.rect.origin.y))
                    context.addLine(to: CGPoint(x:rect.rect.origin.x+20, y: rect.rect.origin.y-20))

                   if rect.layer == "1"{
                       array11.append(rect)
                   }else if rect.layer == "2"{
                       array12.append(rect)
                   }else if rect.layer == "3"{
                       array13.append(rect)
                
                    }
                }
                
                if array11.count>0{
                    var x1  =   CGFloat(MAXFLOAT)
                    var x2  =   CGFloat(0)
                    
                    
                    for rect in array11{
                        
                        if rect.rect.origin.x > x2 {
                            x2 = rect.rect.origin.x
                        }
                        if rect.rect.origin.x < x1 {
                            x1 = rect.rect.origin.x
                        }
                    }
                    //竖线
                    context.move(to: CGPoint(x:x1+20+(x2-x1)/2, y: array11[0].rect.origin.y-20))
                    context.addLine(to: CGPoint(x:x1+20+(x2-x1)/2, y: array11[0].rect.origin.y-40))
                    if array11.count>1{
                        //横线
                        context.move(to: CGPoint(x: x1+19, y: array11[0].rect.origin.y-20))
                        context.addLine(to: CGPoint(x: x2+21, y: array11[0].rect.origin.y-20))
                    }
                    
                }
                
                
              if array12.count>0{
                    var x1  =   CGFloat(MAXFLOAT)
                    var x2  =   CGFloat(0)
                    
                    
                    for rect in array12{
                        
                        if rect.rect.origin.x > x2 {
                            x2 = rect.rect.origin.x
                        }
                        if rect.rect.origin.x < x1 {
                            x1 = rect.rect.origin.x
                        }
                    }
                    //竖线
                    context.move(to: CGPoint(x:x1+20+(x2-x1)/2, y: array12[0].rect.origin.y-20))
                    context.addLine(to: CGPoint(x:x1+20+(x2-x1)/2, y: array12[0].rect.origin.y-40))
                
               
                if array12.count>1{
                    //横线
                    context.move(to: CGPoint(x: x1+19, y: array12[0].rect.origin.y-20))
                    context.addLine(to: CGPoint(x: x2+21, y: array12[0].rect.origin.y-20))
                }
                
                }

                
                if array13.count>0{
                    var x1  =   CGFloat(MAXFLOAT)
                    var x2  =   CGFloat(0)
                    
                    
                    for rect in array13{
                        
                        if rect.rect.origin.x > x2 {
                            x2 = rect.rect.origin.x
                        }
                        if rect.rect.origin.x < x1 {
                            x1 = rect.rect.origin.x
                        }
                    }
                    //竖线
                    context.move(to: CGPoint(x:x1+20+(x2-x1)/2, y: array13[0].rect.origin.y-20))
                    context.addLine(to: CGPoint(x:x1+20+(x2-x1)/2, y: array13[0].rect.origin.y-40))
                    if array13.count > 1{
                        //横线
                        context.move(to: CGPoint(x: x1+19, y: array13[0].rect.origin.y-20))
                        context.addLine(to: CGPoint(x: x2+21, y: array13[0].rect.origin.y-20))
                    }
                    
                }
                
                
               



            }
            
            
            if imagesLineAll.count>3 {
                
                let rectArry = imagesLineAll[3]
                
                
                
                var array11 = [rectSC]()
                var array12 = [rectSC]()
                var array13 = [rectSC]()
                for rect in rectArry{
                    //竖线
                    context.move(to: CGPoint(x:rect.rect.origin.x+20, y: rect.rect.origin.y))
                    context.addLine(to: CGPoint(x:rect.rect.origin.x+20, y: rect.rect.origin.y-20))
                    
                    if rect.layer == "1"{
                        array11.append(rect)
                    }else if rect.layer == "2"{
                        array12.append(rect)
                    }else if rect.layer == "3"{
                        array13.append(rect)
                        
                    }
                }
                
                if array11.count>0{
                    var x1  =   CGFloat(MAXFLOAT)
                    var x2  =   CGFloat(0)
                    
                    
                    for rect in array11{
                        
                        if rect.rect.origin.x > x2 {
                            x2 = rect.rect.origin.x
                        }
                        if rect.rect.origin.x < x1 {
                            x1 = rect.rect.origin.x
                        }
                    }
                    //竖线
                    context.move(to: CGPoint(x:x1+20+(x2-x1)/2, y: array11[0].rect.origin.y-20))
                    context.addLine(to: CGPoint(x:x1+20+(x2-x1)/2, y: array11[0].rect.origin.y-40))
                    if array11.count>1{
                        //横线
                        context.move(to: CGPoint(x: x1+19, y: array11[0].rect.origin.y-20))
                        context.addLine(to: CGPoint(x: x2+21, y: array11[0].rect.origin.y-20))
                    }
                    
                }
                
                
                if array12.count>0{
                    var x1  =   CGFloat(MAXFLOAT)
                    var x2  =   CGFloat(0)
                    
                    
                    for rect in array12{
                        
                        if rect.rect.origin.x > x2 {
                            x2 = rect.rect.origin.x
                        }
                        if rect.rect.origin.x < x1 {
                            x1 = rect.rect.origin.x
                        }
                    }
                    //竖线
                    context.move(to: CGPoint(x:x1+20+(x2-x1)/2, y: array12[0].rect.origin.y-20))
                    context.addLine(to: CGPoint(x:x1+20+(x2-x1)/2, y: array12[0].rect.origin.y-40))
                    
                    
                    if array12.count>1{
                        //横线
                        context.move(to: CGPoint(x: x1+19, y: array12[0].rect.origin.y-20))
                        context.addLine(to: CGPoint(x: x2+21, y: array12[0].rect.origin.y-20))
                    }
                    
                }
                
                
                if array13.count>0{
                    var x1  =   CGFloat(MAXFLOAT)
                    var x2  =   CGFloat(0)
                    
                    
                    for rect in array13{
                        
                        if rect.rect.origin.x > x2 {
                            x2 = rect.rect.origin.x
                        }
                        if rect.rect.origin.x < x1 {
                            x1 = rect.rect.origin.x
                        }
                    }
                    //竖线
                    context.move(to: CGPoint(x:x1+20+(x2-x1)/2, y: array13[0].rect.origin.y-20))
                    context.addLine(to: CGPoint(x:x1+20+(x2-x1)/2, y: array13[0].rect.origin.y-40))
                    if array13.count > 1{
                        //横线
                        context.move(to: CGPoint(x: x1+19, y: array13[0].rect.origin.y-20))
                        context.addLine(to: CGPoint(x: x2+21, y: array13[0].rect.origin.y-20))
                    }
                    
                }
                
                
                
                
                
                
            }
            
            
            
            






        }
        
        
        
        
        //设置笔触颜色
        context.setStrokeColor(UIColor.gray.cgColor)
        //设置笔触宽度
        context.setLineWidth(3)
        //绘制路径
        context.strokePath()
        
    }
}








