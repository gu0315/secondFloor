//
//  MainFrameTableView.swift
//  WeChat
//
//  Created by 顾钱想 on 2023/6/27.
//

import UIKit

class MainFrameTableView: UITableView {
 
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
