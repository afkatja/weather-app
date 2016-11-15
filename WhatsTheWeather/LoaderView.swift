//
//  LoaderView.swift
//  WhatsTheWeather
//
//  Created by Katja Hollaar on 15/11/2016.
//  Copyright © 2016 Katja Hollaar. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    let loader = CAShapeLayer()
    let rad = 20.0
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loader.frame = bounds
        loader.path = circlePath().cgPath
    }
    
    func configure(){
        progress = 0
        loader.frame = bounds
        loader.strokeColor = UIColor.white.cgColor
        loader.fillColor = UIColor.clear.cgColor
        loader.lineWidth = 5
        layer.addSublayer(loader)
        backgroundColor = UIColor.clear
    }
    
    var progress: CGFloat {
        get {
            return loader.strokeEnd
        }
        set {
            if newValue > 1 {
                loader.strokeEnd = 1
            } else if newValue < 0 {
                loader.strokeEnd = 0
            } else {
                loader.strokeEnd = newValue
            }
        }
    }
    
    func loaderPath() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: rad * 2, height: rad * 2)
        circleFrame.origin.x = loader.bounds.midX - circleFrame.midX
        circleFrame.origin.y = loader.bounds.midY - circleFrame.midY
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: loaderPath())
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
