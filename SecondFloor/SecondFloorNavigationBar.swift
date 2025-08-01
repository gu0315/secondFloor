//
//  SecondFloorNavigationBar.swift
//  SecondFloor
//
//  Created by xc on 2025/7/31.
//

import UIKit

class SecondFloorNavigationBar: UIView {
    
    
    var tapActionHandler: (()->Void)?
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIDevice.xp_tabBarHeight()))
        titleLabel.text  = "回到首页"
        titleLabel.textAlignment = .center
        titleLabel.contentMode = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 8
        
        self.addSubview(titleLabel)
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func tapAction() {
        self.tapActionHandler?()
    }
}
