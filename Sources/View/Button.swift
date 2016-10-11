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

    public var redPoint: UIView!
    public var titleLabel: UILabel!
    public var imageView: UIImageView!
    
    public var title: NSAttributedString?
    public var touchAction: ((_ buttonTag: Int) -> Void) = {_ in }
    
    public var buttonGrayColor = UIColor(red:0.945, green:0.945, blue:0.945, alpha:1)
    
    public init(frame: CGRect, title: NSAttributedString, image: UIImage, touchAction: @escaping ((_ buttonTag: Int) -> Void)) {
        
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = image
        
        self.title = title
        self.titleLabel = UILabel()
        self.titleLabel.attributedText = title
        self.titleLabel.textAlignment = .center
        
        self.touchAction = touchAction
        
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
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
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // 设置约束
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -15))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -30))
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // 设置高度
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20))
        // 设置约束
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        
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
