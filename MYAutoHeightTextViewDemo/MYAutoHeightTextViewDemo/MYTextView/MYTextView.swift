//
//  MYTextView.swift
//  MYAutoHeightTextViewDemo
//
//  Created by 朱益锋 on 2017/2/20.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

protocol MYTextViewDelegate: UITextViewDelegate {
    func textView(_ textView: MYTextView, didChangedHeight height: CGFloat)
}

@IBDesignable
class MYTextView: UITextView {
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 5 + self.textContainerInset.left,
                             y: self.textContainerInset.top,
                             width: self.frame.size.width - (self.textContainerInset.left + self.textContainerInset.right),
                             height: self.frame.size.height - (self.textContainerInset.top + self.textContainerInset.bottom))
        label.textColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)
        return label
    }()
    
    fileprivate let separatorColor = UIColor(white: 221/255, alpha: 1)
    
    fileprivate var maxHeight: CGFloat = 0
    
    weak var my_delegate: MYTextViewDelegate?
    
    var originalHeight: CGFloat = 0.0
    
    @IBInspectable var maxNumbersOfLine: Int = 1 {
        didSet {
            self.maxHeight = ceil(self.font!.lineHeight*CGFloat(self.maxNumbersOfLine)+self.textContainerInset.top+self.textContainerInset.bottom)
        }
    }
    
    @IBInspectable var placeHolder: String {
        get {
            if let text = self.placeholderLabel.text {
                return text
            }else {
                return "请输入..."
            }
        }
        set {
            self.placeholderLabel.text = newValue
            self.placeholderLabel.sizeToFit()
        }
    }
    
    override var text: String! {
        didSet {
            self.showOrHiddenPlaceholderLabel()
        }
    }
    
    override var font: UIFont? {
        didSet {
            self.placeholderLabel.font = self.font
            self.placeholderLabel.sizeToFit()
        }
    }
    
    var currentHeihgt: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            if self.currentHeihgt != newValue {
                self.isScrollEnabled = newValue > self.maxHeight && self.maxHeight > 0
                
                if !self.isScrollEnabled {
                    self.my_delegate?.textView(self, didChangedHeight: max(newValue, self.originalHeight))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.originalHeight = self.frame.size.height
    }
    
    fileprivate func setup() {
        
        self.addSubview(self.placeholderLabel)
        
        self.isScrollEnabled = false
        self.scrollsToTop = false
        self.showsHorizontalScrollIndicator = false
        self.enablesReturnKeyAutomatically = true
        self.layer.cornerRadius = 5
        self.layer.borderColor = separatorColor.cgColor
        self.layer.borderWidth = 0.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(MYTextView.textViewDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    func textViewDidChange() {
        self.showOrHiddenPlaceholderLabel()
        let height = self.changedheight()
        self.currentHeihgt = height
    }
    
    func showOrHiddenPlaceholderLabel() {
        self.placeholderLabel.isHidden = self.text != nil && self.text.characters.count > 0
    }
    
    func changedheight() -> CGFloat {
        return ceil(self.sizeThatFits(CGSize(width: self.bounds.size.width, height: CGFloat.greatestFiniteMagnitude)).height)
    }
   

}
