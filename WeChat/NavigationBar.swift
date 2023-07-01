//
//  MMUINavigationBar.swift
//  WeChat
//
//  Created by 顾钱想 on 2023/6/27.
//

import UIKit

class NavigationBar: UIView {
    
    let contentView: UIView = {
        let view = UIView.init(frame: .init(x: 0, y: -UIDevice.xp_statusBarHeight(), width: UIScreen.main.bounds.size.width, height: UIDevice.xp_navigationFullHeight()))
        view.backgroundColor = .white
        return view
    }()

    let titleLabel: UILabel = {
        let lab = UILabel()
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(contentView)
        titleLabel.frame = CGRect.init(x: 0, y: UIDevice.xp_statusBarHeight(), width: frame.size.width, height: frame.size.height)
        titleLabel.text  = "微信(0)"
        titleLabel.textAlignment = .center
        titleLabel.contentMode = .center
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    /// TODO
    func setBottomFream() {
        contentView.y = 0
        titleLabel.centerY  = contentView.centerY
    }
    
    /// TODO
    func setTopFream() {
        contentView.y = -UIDevice.xp_statusBarHeight()
        titleLabel.y  = UIDevice.xp_statusBarHeight()
    }
}
