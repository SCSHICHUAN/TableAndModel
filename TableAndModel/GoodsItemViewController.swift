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
    var goodsDict:Dictionary<String,UIImage>!
    var images:Array<String>!
    var goodsJSON:NSDictionary!
    var imagesLine = [CGRect]()
    var imagesLine1 = [CGRect]()
    var imagesLine2 = [CGRect]()
    var imagesLineAll = [[CGRect]()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = name
        let imageV    = self.view.viewWithTag(115) as! UIImageView
        imageV.image = image
        let morge  = (UIScreen.main.bounds.width/CGFloat(images.count))
        
        if images.count>0 {
            for i in 1...images.count{
               
                let imageView = UIImageView(frame: CGRect(x:CGFloat(i-1)*morge + morge/2-40/2, y: 200, width: 40, height: 40))
                imagesLine.append(CGRect(x:CGFloat(i-1)*morge + morge/2-40/2, y: 200, width: 40, height: 40))
                imageView.image = goodsDict[images[i-1]]
                print("hh = \(i)=\(images[i-1])")
                self.view .addSubview(imageView)
                
                let object = goodsJSON[images[i-1]] as! NSDictionary
                
                
                
               var images2 = [String]()
                for key111 in object.allKeys {
                    if (key111 as! String) == "from"{
                        images2 = object["from"] as! Array<String>
                         let morge2 =  morge/CGFloat(images2.count)
                        
                        if images2.count>0 {
                            
                            for i in 1...images2.count{
                                
                                let imageView = UIImageView(frame: CGRect(x:CGFloat(i-1)*morge2 + morge2/2-40/2, y: 280, width: 40, height: 40))
                                imageView.image = goodsDict[images2[i-1]]
                                self.view .addSubview(imageView)
                               imagesLine1.append( CGRect(x:CGFloat(i-1)*morge2 + morge2/2-40/2, y: 280, width: 40, height: 40))
                                 var images3 = [String]()
                                 let object = goodsJSON[images2[i-1]] as! NSDictionary
                                for key111 in object.allKeys {
                                    if (key111 as! String) == "from"{
                                        images3 = object["from"] as! Array<String>
                                         let morge3 =  morge2/CGFloat(images3.count)
                                        
                                        for i in 1...images3.count{
                                            
                                            let imageView = UIImageView(frame: CGRect(x:CGFloat(i-1)*morge3 + morge3/2-40/2, y: 360, width: 40, height: 40))
                                            imageView.image = goodsDict[images3[i-1]]
                                            self.view .addSubview(imageView)
                                            imagesLine2.append(CGRect(x:CGFloat(i-1)*morge3 + morge3/2-40/2, y: 360, width: 40, height: 40))
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
    
     var imagesLineAll = [[CGRect]()]
    
    
    init(frame: CGRect,lineRect:Array<Array<CGRect>>) {
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
        
      
        
        context.move(to: CGPoint(x: UIScreen.main.bounds.width/2-1.5, y: 154))
        context.addLine(to: CGPoint(x:UIScreen.main.bounds.width/2-1.5, y: 180))
        
        
        if imagesLineAll.count>1 {
            
           
            
            let x =   (imagesLineAll[1].first?.origin.x)!+19
            let x2 =   (imagesLineAll[1].last?.origin.x)!+21

            context.move(to: CGPoint(x: x, y: 180))
            context.addLine(to: CGPoint(x: x2, y: 180))
            
            let rectArry = imagesLineAll[1]
            
            for rect in rectArry{
                let rect = rect
               
                context.move(to: CGPoint(x: rect.origin.x+20, y: 179))
                context.addLine(to: CGPoint(x: rect.origin.x+20, y: 200))
    
            }
            
            if imagesLineAll.count>2 {
                
                 let rectArry = imagesLineAll[2]

                let x =   (rectArry.first?.origin.x)!+19
                var x2  =   CGFloat(0)

                for rect in rectArry{
                    let rect = rect
  
                    context.move(to: CGPoint(x: rect.origin.x+20, y: 179+80))
                    context.addLine(to: CGPoint(x: rect.origin.x+20, y: 200+80))

                    if rect.origin.x > x2 {
                         x2 = rect.origin.x
                    }

                }
               //横线
                context.move(to: CGPoint(x: x, y: 180+80))
                context.addLine(to: CGPoint(x: x2+21, y: 180+80))
                
                //竖线
                context.move(to: CGPoint(x:x+(x2+21-x)/2, y: 180+80))
                context.addLine(to: CGPoint(x:x+(x2+21-x)/2, y: 180+59))
                
            }
            
            if imagesLineAll.count>3 {

                let rectArry = imagesLineAll[3]
                
                let x =   (rectArry.first?.origin.x)!+19
                var x2  =   CGFloat(0)
                
                for rect in rectArry{
                    let rect = rect
                    
                    context.move(to: CGPoint(x: rect.origin.x+20, y: 179+80+101))
                    context.addLine(to: CGPoint(x: rect.origin.x+20, y: 200+80+64))
                    
                    if rect.origin.x > x2 {
                        x2 = rect.origin.x
                    }
                    
                }
                 //横线
                context.move(to: CGPoint(x: x, y: 200+80+64))
                context.addLine(to: CGPoint(x: x2+21, y: 200+80+64))

               //竖线
                context.move(to: CGPoint(x:x+(x2+21-x)/2, y: 179+80+61))
                context.addLine(to: CGPoint(x:x+(x2+21-x)/2, y: 179+80+85))

            }
            
            
//            if imagesLineAll.count>4 {
//
//                let x =   (imagesLineAll[4].first?.origin.x)!+19
//                let x2 =   (imagesLineAll[4].last?.origin.x)!+21
//
//                context.move(to: CGPoint(x: x, y: 180))
//                context.addLine(to: CGPoint(x: x2, y: 180))
//
//                let rectArry = imagesLineAll[4]
//
//                for rect in rectArry{
//                    let rect = rect
//
//                    context.move(to: CGPoint(x: rect.origin.x+20, y: 179))
//                    context.addLine(to: CGPoint(x: rect.origin.x+20, y: 200))
//
//                }
//
//            }
            
            
            
            
            
            
        }
        
        
        
        
        //设置笔触颜色
        context.setStrokeColor(UIColor.gray.cgColor)
        //设置笔触宽度
        context.setLineWidth(3)
        //绘制路径
        context.strokePath()
        
    }
}








