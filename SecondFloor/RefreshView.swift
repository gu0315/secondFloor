//
//  RefreshView.swift
//  SecondFloor
//
//  Created by xc on 2025/8/1.
//

import UIKit

class RefreshView: UIView {
    
    lazy var refreshLab: UILabel = {
        let lab = UILabel(frame: .init(x: 0, y: 0, width: 200, height: 44))
        lab.centerX = self.centerX
        lab.textAlignment = .center
        lab.text = "下拉刷新"
        lab.numberOfLines = 1
        lab.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        lab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        return lab
    }()
    
    private let progressLayer = CALayer()
    
    
    private let fillLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
        self.setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.addSubview(self.refreshLab)
    }
    
    
    func setupLayer() {
        
    
        let scale = UIScreen.main.bounds.width / 375.0
        let w = scale * 113
        let h = scale * 3

        progressLayer.frame = CGRect(x: (self.frame.width - w) / 2, y: 45, width: w, height: h)
        progressLayer.addSublayer(fillLayer)
        progressLayer.backgroundColor =  UIColor(red: 1, green: 203/255.0, blue: 215/255.0, alpha: 1).cgColor
        progressLayer.masksToBounds = true
        progressLayer.cornerRadius = h / 2
        
    
        fillLayer.frame = CGRect(x: (w - 16 * scale) / 2, y: 0, width: 16 * scale, height: 3 * scale)
        fillLayer.backgroundColor = UIColor.white.cgColor
        progressLayer.addSublayer(fillLayer)
    
        self.layer.addSublayer(progressLayer)
    }
    
    func updateProgressWithPercent(_ percent: CGFloat) {
        let width = max(0.14, min(1, percent)) * progressLayer.bounds.width
        fillLayer.frame = CGRect(x: (progressLayer.bounds.width - width) / 2, y: 0, width: width, height: fillLayer.bounds.height)
    }
    
    
    func setText(text: String) {
        self.refreshLab.text = text
    }

}

