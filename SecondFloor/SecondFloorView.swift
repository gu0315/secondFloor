//
//  SecondFoorView.swift
//  SecondFloor
//
//  Created by xc on 2025/7/31.
//

import UIKit


fileprivate let cellId = "UICollectionViewCell"

/// 动画时间
let animationTimeinterval: TimeInterval = 0.35


protocol SecondFloorDidScrollDelegate {
    func secondFloorViewDidScroll(_ scrollView: UIScrollView)
}

extension SecondFloorView {
    
    
    /// 根据百分比调整视图的缩放和位移
    /// - Parameter percent: 百分比
    func transformWithPercent(_ percent: CGFloat) {
        // 计算视图的缩放比例
        let scale = percent * (1 - minScale) + minScale
        // 计算垂直位移
        let y = self.updownBeginY * (1 - percent)
        self.contentView.transform = CGAffineTransform.init(translationX: 0, y: -y).scaledBy(x: scale, y: scale)
    }
    
    
    /// 初始化视图的变换状态
    func initTransform() {
        self.contentView.transform = CGAffineTransform.init(translationX: 0, y: -(self.updownBeginY)).scaledBy(x: minScale, y: minScale)
    }
    
    /// 进入一楼关闭当前视图
    func dismissViewWithAnimation() {
        guard self.isAnimation == false else {return}
        self.isAnimation = true
        UIView.animate(withDuration: animationTimeinterval) {
            self.contentView.transform = CGAffineTransform.init(translationX: 0, y: -self.contentView.bounds.height)
        } completion: { _ in
            self.isAnimation = false
            self.initTransform()
        }
    }
}


class SecondFloorView: UIView {
    

    
    fileprivate var isAnimation: Bool = false
    
    var delegate: SecondFloorDidScrollDelegate?
    
    fileprivate let minScale: CGFloat = 0.7
    
    fileprivate var updownBeginY: CGFloat {
        return (self.bounds.height - self.bounds.height * self.minScale) * 0.5
    }
    
    
    // 底部Bar
    lazy var navigationBar: SecondFloorNavigationBar = {
        let view = SecondFloorNavigationBar.init(frame: .init(x: 0, y: height-UIDevice.xp_tabBarFullHeight(), width: UIScreen.main.bounds.size.width, height: UIDevice.xp_tabBarFullHeight()))
        return view
    }()
    
    lazy var contentView: UIScrollView = {
        let contentView = UIScrollView(frame: self.bounds)
        contentView.frame = .init(x: 0, y: 0, width: width, height: height)
        contentView.backgroundColor = .gray
        contentView.delegate = self
        return contentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
        self.initTransform()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func configureView() {
        
        self.addSubview(self.contentView)
        self.addSubview(self.navigationBar)
        
        self.backgroundColor = .lightGray
        
        self.contentView.frame = .init(x: 0, y: 0, width: width, height: height)
        
        contentView.isScrollEnabled = true
        var contentHeight: CGFloat = 0
        for i in 0..<20 {
            let lab = UILabel.init(frame: .init(x: 0, y: i*50, width: Int(width), height: i*50))
            lab.text = "\(i)"
            self.contentView.addSubview(lab)
            contentHeight = contentHeight + 50
        }
        self.contentView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        self.contentView.contentSize = CGSize(width: width, height: contentHeight + height)
    }
    
}


extension SecondFloorView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.delegate != nil) {
            self.delegate?.secondFloorViewDidScroll(scrollView)
        }
    }
}

