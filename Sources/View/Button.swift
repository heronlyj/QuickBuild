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

    public var redPoint = UIView()
    public var titleLabel = UILabel()
    public var imageView = UIImageView()
    
    public var title: NSAttributedString? {
        didSet {
            titleLabel.attributedText = title
        }
    }
    
    public var touchAction: ((_ buttonTag: Int) -> Void) = {_ in }
    
    public var buttonGrayColor = UIColor(red:0.945, green:0.945, blue:0.945, alpha:1)
    
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
        
        let redPointFrame = CGRect(x: frame.size.width - 20, y: 20, width: 9, height: 9)
        self.redPoint = UIView(frame: redPointFrame)
        self.redPoint.backgroundColor = UIColor.red
        self.redPoint.layer.cornerRadius = 4.5
        self.redPoint.layer.masksToBounds = true
        self.redPoint.isHidden = true
        self.addSubview(redPoint)
        
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(recongnizer:)))
        self.addGestureRecognizer(longPress)
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateConstraints()
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        // 设置约束
        layout(item: imageView, attribute: .top, to: self, constant: 15)
        layout(item: imageView, attribute: .top, to: self, constant: 15)
        layout(item: imageView, attribute: .left, to: self, constant: 15)
        layout(item: imageView, attribute: .right, to: self, constant: -15)
        layout(item: imageView, attribute: .bottom, to: self, constant: -30)

        // 设置高度
        layout(item: titleLabel, attribute: .height, to: nil, constant: 20)
        
        // 设置约束
        layout(item: titleLabel, attribute: .left, to: self, constant: 0)
        layout(item: titleLabel, attribute: .right, to: self, constant: 0)
        layout(item: titleLabel, attribute: .bottom, to: self, constant: -5)
        
    }
    
    
    @objc private func tapAction() {
        self.touchAction(self.tag)
        self.redPoint.isHidden = true
        self.layer.add(createfadeAnimation(), forKey: nil)
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    
    @objc private func longPressAction(recongnizer: UILongPressGestureRecognizer) {
        if recongnizer.state == UIGestureRecognizerState.began {
            self.backgroundColor = buttonGrayColor
        } else if recongnizer.state == UIGestureRecognizerState.ended {
            self.backgroundColor = UIColor.white
            self.touchAction(self.tag)
            self.redPoint.isHidden = true
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
