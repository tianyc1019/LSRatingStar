//
//  ViewController.swift
//  LSRatingStar
//
//  Created by John_LS on 2017/1/2.
//  Copyright © 2017年 John_LS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let star : LSRatingStar = LSRatingStar.init(frame: CGRect(x:10, y:150,width:300 ,height:25)) { (ratingStar, rating) in
            print("值变成了 ====  "+"\(rating)")
        }
        view.addSubview(star)
        star.rating = 3.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

