//
//  MainFrameTopHeaderView.swift
//  WeChat
//
//  Created by 顾钱想 on 2023/6/27.
//

import UIKit

protocol TopHeaderViewDidScrollDelegate {
    func topHeaderViewDidScroll(_ scrollView: UIScrollView)
}

class MainFrameTopHeaderView: UIView {
    
    var delegate: TopHeaderViewDidScrollDelegate?
    
    let navigationBar: UIView = {
        let view = UIView.init(frame: .init(x: 0, y: -UIDevice.xp_navigationFullHeight(), width: UIScreen.main.bounds.size.width, height: UIDevice.xp_navigationFullHeight()))
        let titleLabel = UILabel.init()
        titleLabel.frame = CGRect.init(x: 0, y: UIDevice.xp_statusBarHeight(), width: kScreenWidth, height: UIDevice.xp_navigationBarHeight())
        titleLabel.text  = "最近"
        titleLabel.textAlignment = .center
        titleLabel.contentMode = .center
        titleLabel.numberOfLines = 1
        view.addSubview(titleLabel)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView.init(frame: .init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - UIDevice.xp_navigationFullHeight()), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        // 容过少时也能滑动
        collectionView.alwaysBounceVertical = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.addSubview(self.navigationBar)
        self.addSubview(self.collectionView)
        self.collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.collectionView
    }
}

extension MainFrameTopHeaderView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.delegate != nil) {
            self.delegate?.topHeaderViewDidScroll(scrollView)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (scrollView.contentOffset.y > 80) {
           
        }
    }
}

extension MainFrameTopHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}

extension MainFrameTopHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 120
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}
