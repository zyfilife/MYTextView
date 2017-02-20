//
//  ViewController.swift
//  MYAutoHeightTextViewDemo
//
//  Created by 朱益锋 on 2017/2/20.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MYTextViewDelegate {

    @IBOutlet weak var textView: MYTextView!
    @IBOutlet weak var heightOfTextView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.my_delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func textView(_ textView: MYTextView, didChangedHeight height: CGFloat) {
        
        self.heightOfTextView.constant = height+16
        
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
}

