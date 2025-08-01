//
//  RefreshView.swift
//  SecondFloor
//
//  Created by xc on 2025/8/1.
//

import UIKit

class RefreshView: UIView {
    
//    lazy var refreshIcon: UIImageView = {
//        let icon = UIImageView(frame: .init(x: 0, y: 0, width: 40, height: 40))
//        refreshIcon.centerX = self.centerX
//        return icon
//    }()
    
    lazy var refreshLab: UILabel = {
        let lab = UILabel(frame: .init(x: 0, y: 0, width: 200, height: 40))
        lab.centerX = self.centerX
        lab.textAlignment = .center
        lab.text = "下拉刷新"
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.addSubview(self.refreshLab)
    }
    
    func setText(text: String) {
        self.refreshLab.text = text
    }

}
