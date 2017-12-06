//
//  ViewController.swift
//  SuspendButton
//
//  Created by 王垒 on 2017/12/4.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myButton : WLButton!
    
    // 控制tabbar的显示与隐藏标志
    // Control of the tabbar show and hide mark
    var flag : Bool?
    
    // 是否点击过
    // Ever click
    var isExpanding : Bool = false
    
    var btnArray : [UIButton]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    
    // MARK: - createUI
    func createUI(){
        
        self.view.backgroundColor = UIColor.yellow
        
        myButton = WLButton(type: .custom)
        
        myButton.moveEnable = true
        
        myButton.frame = CGRect(x: WLWindowWidth - 40, y: WLWindowHeight - 40, width: 40, height: 40)
        
        myButton.setBackgroundImage(UIImage.init(named: "1"), for: .normal)
        
        myButton.tag = 20171204155324
        
        flag = false
        
        myButton.addTarget(self, action: #selector(ViewController.myButtonClick), for: .touchUpInside)
        
        self.view.addSubview(myButton)
        
        initButton()
    }
    
    func initButton(){
        
        let buttonCenter = CGPoint(x: myButton.frame.size.width / 2, y: myButton.frame.size.height / 2)
        
        let btn1 = createBtn(center: buttonCenter, imageName: "1")
        
        btn1.addTarget(self, action: #selector(ViewController.btn1Click), for: .touchUpInside)
        
        self.view.addSubview(btn1)
        
        let btn2 = createBtn(center: buttonCenter, imageName: "2")
        
        btn2.addTarget(self, action: #selector(ViewController.btn2Click), for: .touchUpInside)
        
        self.view.addSubview(btn2)
        
        btnArray = []
        
        btnArray?.append(btn2)
        
        btnArray?.append(btn1)
    }
    
    func createBtn(center : CGPoint ,imageName : String) -> UIButton{
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        
        btn.setBackgroundImage(UIImage.init(named: imageName), for: .normal)
        
        btn.center = center
        
        btn.alpha = 0
        
        return btn
    }
    
    func myButtonClick(){
        
        if !myButton.moveEnabled {
            if !isExpanding{
                
                // 初始未展开
                // The initial unexpanded
                let angle = CGAffineTransform.init(rotationAngle: 0)
                
                UIView.animate(withDuration: 0.3, animations: {
                    // 动画开始
                    // Animation start
                    self.myButton.transform = angle
                    
                }, completion: { [weak self](finished) in
                    
                    // 动画结束
                    // End of the animation
                    self?.myButton.transform = angle
                    
                    self?.myButton.setBackgroundImage(UIImage.init(named: "3"), for: .normal)
                })
                
                showButtonAnimated()
                
                isExpanding = true
                
            }else{
                
                // 已展开
                // Have begun
                let unangle = CGAffineTransform(rotationAngle: 0)
                
                UIView.animate(withDuration: 0.3, animations: {
                    // 动画开始
                    // Animation start
                    self.myButton.transform = unangle
                    
                }, completion: { [weak self](finished) in
                    
                    // 动画结束
                    // End of the animation
                    self?.myButton.transform = unangle
                    
                    self?.myButton.setBackgroundImage(UIImage.init(named: "1"), for: .normal)
                })
                
                hideButtonsAnimated()
                
                isExpanding = false
            }
        }
    }
    
    func btn1Click(){
        
        let alertVC = createOnlyAlertVC(AlertTitle: "", AlertMessage: "打开简书，关注王垒iOS", cancelActionTitle: "好的")
        
        self.navigationController?.present(alertVC, animated: true, completion: nil)
    }
    
    func btn2Click(){
        
        let alertVC = createOnlyAlertVC(AlertTitle: "", AlertMessage: "Open the book, Jane attention Wang Lei iOS", cancelActionTitle: "Ok")
        
        self.navigationController?.present(alertVC, animated: true, completion: nil)
    }
    
    func createOnlyAlertVC(AlertTitle: String, AlertMessage: String, cancelActionTitle: String) -> UIAlertController{
        
        let alertVC = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: {
            
            _ in
        })
        
        alertVC.addAction(cancelAction)
        
        return alertVC
    }
    
    func showButtonAnimated(){
        
        let x = myButton.center.x
        
        let y = myButton.center.y
        
        var endX = x
        
        var endY = y
        
        for i in 0..<(btnArray?.count)! {
            
            let btn = btnArray![i]
            
            // 最终坐标
            // In the end coordinates
            endX = endX + 0
            endY = endY - (btn.frame.size.height + 30)
            
            // 反弹坐标
            // Rebound coordinates
            let farX = endX - 0
            
            let farY = endY - 30
            
            let nearX = endX + 0
            
            let nearY = endY + 15
            
            // 动画集合
            // Collection of animation
            var animationOptions: [CAKeyframeAnimation] = []

            // 旋转动画
            // Rotating animation
            let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            
            rotateAnimation.values = NSArray(objects: NSNumber(value: 0.0),NSNumber(value: Float(Double.pi * 2))) as? [Any]

            rotateAnimation.duration = 0.4
            
            rotateAnimation.keyTimes = NSArray(objects: NSNumber(value: 0.0),NSNumber(value: 1.0)) as? [NSNumber]

            animationOptions.append(rotateAnimation)
            
            // 位置动画
            // Location of the animation
            let positionAnimation = CAKeyframeAnimation.init(keyPath: "position")
            
            positionAnimation.duration = 0.4
            
            let path = CGMutablePath.init()
            
            path.move(to: CGPoint(x: x, y: y))
            
            path.addLine(to: CGPoint(x: farX, y: farY))
            
            path.addLine(to: CGPoint(x: nearX, y: nearY))
            
            path.addLine(to: CGPoint(x: endX, y: endY))
            
            positionAnimation.path = path
            
            animationOptions.append(positionAnimation)

            
            let animationGroup = CAAnimationGroup()
            
            animationGroup.animations = animationOptions
            
            animationGroup.duration = 0.4
            
            animationGroup.fillMode = kCAFillModeForwards
            
            animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let properties = NSMutableDictionary()
            
            properties.setValue(btn, forKey: "view")
            
            properties.setValue(NSValue(cgPoint: CGPoint.init(x: endX, y: endY)), forKey: "center")
            
            properties.setValue(animationGroup, forKey: "animation")
            

            self.perform(#selector(ViewController.expand(properties:)), with: properties, afterDelay: 0.1 * Double((self.btnArray?.count)! - i))
        }
    }
    
    func hideButtonsAnimated(){
        
        let endX = myButton.center.x
        
        let endY = myButton.center.y
        
        for i in 0..<(btnArray?.count)! {
            
            let btn = btnArray![i]
            
            // 动画集合
            // Collection of animation
            var animationOptions: [CAKeyframeAnimation] = []
            
            // 旋转动画
            // Rotating animation
            let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            
            rotateAnimation.values = NSArray(objects: NSNumber(value: 0.0),NSNumber(value: Float(Double.pi * -2))) as? [Any]
            
            rotateAnimation.duration = 0.4
            
            rotateAnimation.keyTimes = NSArray(objects: NSNumber(value: 0.0),NSNumber(value: 1.0)) as? [NSNumber]
            
            animationOptions.append(rotateAnimation)
            
            // 透明度
            // transparency
            let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
            
            opacityAnimation.values = NSArray(objects: NSNumber(value: 1.0),NSNumber(value: 0.0)) as? [Any]
            
            opacityAnimation.duration = 0.4
        
            animationOptions.append(opacityAnimation)
            
            // 位置动画
            // Location of the animation
            let positionAnimation = CAKeyframeAnimation.init(keyPath: "position")
            
            positionAnimation.duration = 0.4
            
            let x = btn.center.x
            
            let y = btn.center.y
            
            let path = CGMutablePath.init()
            
            path.move(to: CGPoint(x: x, y: y))
            
            path.addLine(to: CGPoint(x: endX, y: endY))
            
            positionAnimation.path = path
            
            animationOptions.append(positionAnimation)

            let animationGroup = CAAnimationGroup()
            
            animationGroup.animations = animationOptions
            
            animationGroup.duration = 0.4
            
            animationGroup.fillMode = kCAFillModeForwards
            
            animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let properties = NSMutableDictionary()
            
            properties.setValue(btn, forKey: "view")
            
            properties.setValue(animationGroup, forKey: "animation")
            
            self.perform(#selector(ViewController.close(properties:)), with: properties, afterDelay: 0.1 * Double((self.btnArray?.count)! - i))
            
        }
    }
    
    // 弹出
    // The pop-up
    func expand(properties : NSDictionary){
        
        let view = properties.object(forKey: "view") as! UIView
        
        let animationGroup = properties.object(forKey: "animation") as! CAAnimationGroup
        
        let val = properties.object(forKey: "center") as! NSValue
        
        let center = val.cgPointValue
        
        view.layer.add(animationGroup, forKey: "Expand")
        
        view.center = center
        
        view.alpha = 1
    }
    
    // 收起
    // Pack up
    func close(properties : NSDictionary){
        
        let view = properties.object(forKey: "view") as! UIView
        
        let animationGroup = properties.object(forKey: "animation") as! CAAnimationGroup
        
        let center = myButton.center
        
        view.layer.add(animationGroup, forKey: "Collapse")
        
        view.center = center
        
        view.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

