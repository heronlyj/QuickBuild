    //
//  ViewController.swift
//  example
//
//  Created by lyj on 11/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit
import QuickBuild

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 120))
        var imageSize = btnFrame.size
        imageSize.height -= 20
        let image = UIImage.drawImage(size: imageSize, color: UIColor.red)
        let title = NSAttributedString(string: "btn")
        let btn = Button(frame: btnFrame, title: title, image: image) { (tag) in
            
        }
        btn.tag = 100
        btn.center = view.center
        
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.green.cgColor
        
//        view.addSubview(btn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

