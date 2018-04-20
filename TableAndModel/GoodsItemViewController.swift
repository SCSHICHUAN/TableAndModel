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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = name
        let imageV    = self.view.viewWithTag(115) as! UIImageView
        imageV.image = image
        let morge  = (UIScreen.main.bounds.width/CGFloat(images.count))
       
        
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








