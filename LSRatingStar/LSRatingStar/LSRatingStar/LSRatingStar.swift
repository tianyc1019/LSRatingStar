//
//  LSRatingStar.swift
//  LSRatingStar
//
//  Created by John_LS on 2017/1/2.
//  Copyright © 2017年 John_LS. All rights reserved.
//

import UIKit

/// 值变化回调
typealias ls_ratingChange = (_ ratingStar: LSRatingStar ,_ rating : CGFloat) -> Void
class LSRatingStar: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var rating : CGFloat = 0{//当前数值
        didSet{
            if minimumRating > rating {rating = minimumRating}
            else if maximumRating < rating {rating = maximumRating}
            //回调给代理
            if ratingChangeed != nil {
                weak var weakSelf = self
                ratingChangeed!(weakSelf!,rating)
            }
            
            let animationTimeInterval = self.canAnimation ? self.animationTimeInterval : 0
            //开启动画改变foregroundRatingView可见范围
            UIView.animate(withDuration: animationTimeInterval, animations: {self.animationRatingChange()})
            self.setNeedsLayout()
        }
    }
    @IBInspectable var maximumRating : CGFloat = 5.0//最大值,必须为numStars的倍数
    @IBInspectable var minimumRating : CGFloat = 0.0//最小值,必须为numStars的倍数
    
    @IBInspectable var numStars : Int = 5 //星星总数
    @IBInspectable var canAnimation : Bool = false//是否开启动画模式
    @IBInspectable var animationTimeInterval : TimeInterval = 0.1//动画时间
    @IBInspectable var incomplete : Bool = true//评分时是否允许半颗星
    @IBInspectable var isIndicator : Bool = false//RatingBar是否是一个指示器（用户无法进行更改）
    
    var spacing : CGFloat = 15.0 //星星之间的间距
    
    
    @IBInspectable var img_Light : UIImage = UIImage(named: "ic_ratingbar_star_light")!
    @IBInspectable var img_dark : UIImage = UIImage(named: "ic_ratingbar_star_dark")!
    
    var v_highlightRating : UIView! ///高亮星view
    var v_bgRating : UIView! ///背景星viw
    
    var ratingChangeed : ls_ratingChange? = nil ///值变化时的回调
    var isDrew : Bool = false

    
    /// xib中可以直接用，但是需要将下面两个方法注释，不然会崩溃
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
        let animationTimeInterval = self.canAnimation ? self.animationTimeInterval : 0
        //开启动画改变foregroundRatingView可见范围
        UIView.animate(withDuration: animationTimeInterval, animations: {self.animationRatingChange()})
    }
    
//     init(frame: CGRect , ratingChange :  ls_ratingChange?){
//        super.init(frame: frame)
//        ratingChangeed = ratingChange
//        setupUI()
//        let animationTimeInterval = self.canAnimation ? self.animationTimeInterval : 0
//        //开启动画改变foregroundRatingView可见范围
//        UIView.animate(withDuration: animationTimeInterval, animations: {self.animationRatingChange()})
//    }
//   
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
extension LSRatingStar {
    fileprivate func setupUI() {
        if isDrew {return}
        isDrew = true
        //创建前后两个View，作用是通过rating数值显示或者隐藏“foregroundRatingView”来改变RatingBar的星星效果
        v_bgRating = setupRatingView(img_dark)
        v_highlightRating = setupRatingView(img_Light)
        animationRatingChange()
        self.addSubview(v_bgRating)
        self.addSubview(v_highlightRating)
        //加入单击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRateView(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)

    }
    //根据图片名，创建一列RatingView
    fileprivate func setupRatingView(_ image: UIImage) ->UIView{
        let view = UIView(frame: self.bounds)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        //开始创建子Item,根据numStars总数
        var x : CGFloat = 0.0 //横坐标
        let w : CGFloat = (self.bounds.size.width-spacing*CGFloat((numStars-1))) / CGFloat(numStars) ///星星宽度
        
        for position in 0 ..< numStars{
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: x, y: 0, width: w, height: self.bounds.size.height)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            view.addSubview(imageView)
            
            x += w+spacing
        }
        return view
    }
}
extension LSRatingStar {
    //改变v_highlightRating可见范围
    fileprivate func animationRatingChange(){
        
        let w : CGFloat = (self.bounds.size.width-spacing*CGFloat((numStars-1))) / CGFloat(numStars) ///星星宽度
        let integer : CGFloat = CGFloat(Int(rating)/1)//整数部分
        let w_view : CGFloat = integer*spacing + w*rating
        v_highlightRating.frame = CGRect(x: 0, y: 0,width: w_view, height: self.bounds.size.height)
        
    }
    //点击编辑分数后，通过手势的x坐标来设置数值
    @objc fileprivate func tapRateView(_ sender: UITapGestureRecognizer){
        if isIndicator {return}//如果是指示器，就不能交互
        let tapPoint = sender.location(in: self)
        let offset = tapPoint.x
        //通过x坐标判断分数
        let realRatingScore = offset / (self.bounds.size.width / maximumRating);
        
        calculateRating(realRatingScore: realRatingScore)
    }
    /// 计算分数
    ///
    /// - Parameter realRatingScore: 点击坐标所占比例
    fileprivate func calculateRating(realRatingScore : CGFloat)  {
        if !incomplete {
           rating = round(realRatingScore)
        }else{
            let score : CGFloat = realRatingScore
            let integer : CGFloat = CGFloat(Int(score)/1)//整数部分
            
            let decimal : CGFloat = (score-integer) < 0.5 ? 0.5 : 1.0//小数部分
            
            rating =  integer+decimal
        }
        
    }
}
