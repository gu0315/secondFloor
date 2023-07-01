//
//  ViewController.swift
//  WeChat
//
//  Created by 顾钱想 on 2023/6/25.
//

import UIKit
import  AVFoundation

class ViewController: UIViewController {
    
    var delegate: ShowTabBarDelegate?
    
    var startOffset: CGPoint = .zero
    
    var lastOffsetY: CGFloat = 0.0
    
    var duration: TimeInterval = 0.25
    
    var runTime: TimeInterval = 0
    
    var isFeedback: Bool = false
    
    var lastTrackingContentOffsetY: CGFloat = 0
    
    var isBeginDragging: Bool = false
   
    let navigationBar: NavigationBar = {
        let view = NavigationBar.init(frame: .init(x: 0, y: UIDevice.xp_statusBarHeight(), width: UIScreen.main.bounds.size.width, height: UIDevice.xp_navigationBarHeight()))
        return view
    }()
    
    let headerView: MainFrameTopHeaderView = {
        let view = MainFrameTopHeaderView.init(frame: .init(x: 0, y: -UIScreen.main.bounds.size.height + UIDevice.xp_navigationFullHeight(), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - UIDevice.xp_navigationFullHeight()))
        return view
    }()
    
    let tableView: MainFrameTableView = {
        let view = MainFrameTableView.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        view.contentInset = .init(top: UIDevice.xp_navigationFullHeight(), left: 0, bottom: UIDevice.xp_tabBarFullHeight(), right: 0)
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        return view
    }()
    
    
    var m_isShowTableHeaderTopView: Bool = false
    
    var animtedDisplayLink:  CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.addViews()
        headerView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func addViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.addSubview(navigationBar)
        tableView.addSubview(headerView)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
}

extension ViewController: UIScrollViewDelegate, TopHeaderViewDidScrollDelegate {
    
    func topHeaderViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let actualOffsetY = offsetY + UIDevice.xp_navigationFullHeight()
        if (actualOffsetY > UIDevice.xp_navigationFullHeight() + 40) {
            print("回到一楼")
            if (self.delegate != nil) {
                self.delegate?.showTabBar()
            }
            // 回到一楼
            UIView.animate(withDuration: 0.3) {
                self.headerView.collectionView.isScrollEnabled = false
                self.m_isShowTableHeaderTopView = false
                self.tableView.scrollsToTop = true
                self.navigationBar.y = UIDevice.xp_statusBarHeight()
                self.navigationBar.setTopFream()
                self.tableView.setContentOffset(.init(x: 0, y: -UIDevice.xp_navigationFullHeight()), animated: false)
                self.tableView.isScrollEnabled = true
            } completion: { finished in
                if (!finished) { return }
                if (self.delegate != nil) {
                    self.delegate?.showTabBar()
                }
            }
        }
    }
    
    func goToSecondFloor() {
        if (m_isShowTableHeaderTopView) { return }
        print("即将进入二楼")
        headerView.collectionView.isScrollEnabled = true
        tableView.isScrollEnabled = false
        m_isShowTableHeaderTopView = true
        startOffset = tableView.contentOffset
        runTime = 0
        if (self.delegate != nil) {
            self.delegate?.hiddenTabBar()
        }
        animtedDisplayLink = CADisplayLink(target: self, selector: #selector(animtedScroll))
        animtedDisplayLink?.add(to: .main, forMode: .common)
    }
    
    /// 进入二楼动画
    /// - Parameter displayLink: 屏幕刷新
    @objc func animtedScroll(_ displayLink: CADisplayLink) {
        guard let animtedDisplayLink = animtedDisplayLink else { return }
        runTime += animtedDisplayLink.duration
        if runTime >= duration {
            self.tableView.setContentOffset(.init(x: 0, y: -kScreenHeight), animated: false)
            self.navigationBar.y = kScreenHeight - UIDevice.xp_navigationFullHeight()
            self.navigationBar.setBottomFream()
            animtedDisplayLink.invalidate()
            self.animtedDisplayLink = nil
            if (self.delegate != nil) {
                self.delegate?.hiddenTabBar()
            }
            print("进入二楼完成")
            return
        }
        var offset = tableView.contentOffset
        offset.x = 0
        offset.y = self.compute(CGFloat(runTime), startOffset.y, -kScreenHeight - startOffset.y, CGFloat(duration))
        tableView.setContentOffset(offset, animated: false)
        navigationBar.y = -offset.y - 44
    }
    
    func compute(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
        return -c / 2 * (cos(CGFloat.pi * t / d) - 1) + b
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (m_isShowTableHeaderTopView) { return }
        // 滑动UITableView
        let offsetY = scrollView.contentOffset.y + scrollView.contentInset.top
        scrollView.showsVerticalScrollIndicator = offsetY > 0
        if (offsetY < 0) {
            navigationBar.y = abs(offsetY) + UIDevice.xp_statusBarHeight()
            // 显示小球
            if (offsetY < -criticalPoint0) {
                if (!isFeedback) {
                    // 震动
                    isFeedback = true
                    let feedbackGenerator = UIImpactFeedbackGenerator.init(style: .medium)
                    feedbackGenerator.impactOccurred()
                }
            } else if (offsetY < -criticalPoint1) {
                
            } else if (offsetY < -criticalPoint2) {
                
            } else if (offsetY < -criticalPoint3) {
                
            } else {
                
            }
            if (!scrollView.isTracking && scrollView.contentOffset.y < -criticalPoint2){
                self.goToSecondFloor()
            }
        } else {
            isFeedback = false
            navigationBar.y = UIDevice.xp_statusBarHeight()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isBeginDragging = true
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 如果向下滑动速度过大进入二楼
        if velocity.y < -1 && scrollView.contentOffset.y < -criticalPoint2 {
            self.goToSecondFloor()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {}
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension ViewController {
    
}
