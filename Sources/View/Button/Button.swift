//
//  Button.swift
//  QuickBuild
//
//  Created by lyj on 11/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

enum ButtonImageTitlePostaion {}

public class Button: UIView {

    public var titleLabel = UILabel()
    public var imageView = UIImageView()
    
    public var title: NSAttributedString? {
        didSet {
            titleLabel.attributedText = title
        }
    }
    
    public var touchAction: ((_ buttonTag: Int) -> Void) = {_ in }
    
    public var buttonGrayColor = UIColor(red: 0.945, green: 0.945, blue: 0.945, alpha: 1)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        self.titleLabel.textAlignment = .center
        
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        self.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender:)))
        self.addGestureRecognizer(longPress)
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateConstraints()
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        // 设置约束
        al.layout(item: imageView, attribute: .top, to: self, attribute: .top, constant: 15)
        al.layout(item: imageView, attribute: .left, to: self, attribute: .left, constant: 15)
        al.layout(item: imageView, attribute: .right, to: self, attribute: .right, constant: -15)
        al.layout(item: imageView, attribute: .bottom, to: self, attribute: .bottom, constant: -30)

        // 设置高度
        al.layout(item: titleLabel, attribute: .height, to: nil, attribute: .height, constant: 20)
        
        // 设置约束
        al.layout(item: titleLabel, attribute: .left, to: self, attribute: .left, constant: 0)
        al.layout(item: titleLabel, attribute: .right, to: self, attribute: .right, constant: 0)
        al.layout(item: titleLabel, attribute: .bottom, to: self, attribute: .bottom, constant: -5)
        
    }
    
    
    @objc private func tapAction(sender: UIGestureRecognizer) {
        self.touchAction(self.tag)
        self.layer.add(createfadeAnimation(), forKey: nil)
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    
    @objc private func longPressAction(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            self.backgroundColor = buttonGrayColor
        } else if sender.state == UIGestureRecognizerState.ended {
            self.backgroundColor = UIColor.white
            self.touchAction(self.tag)
        }
    }
    
    private func createfadeAnimation() -> CAKeyframeAnimation {
        let fadeAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")
        fadeAnimation.duration = 0.4
        fadeAnimation.values = [UIColor.white.cgColor, buttonGrayColor.cgColor, UIColor.white.cgColor]
        fadeAnimation.keyTimes = [0.0, 0.2, 0.4]
        fadeAnimation.isRemovedOnCompletion = true
        return fadeAnimation
    }
}
