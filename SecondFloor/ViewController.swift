//
//  ViewController.swift
//  SecondFloor
//
//  Created by xc on 2025/7/31.
//

import UIKit
import Foundation
import AudioToolbox


@objc(ViewController)
class ViewController: UIViewController {
    
    let width = UIScreen.main.bounds.width
    
    let height = UIScreen.main.bounds.height
    
    
    /// 下拉刷新阈值
    let pullTriggerThreshold: Double = 5
    /// 配图消失阈值
    let imageFadeOutThreshold: Double = 20
    /// 松手刷新阈值
    let refreshThreshold: Double = 60
    /// 二楼阈值
    let secondFloorhreshold: Double = 140
   
    /// 是否在执行动画
    fileprivate var doAnimation: Bool = false {
        willSet {
            self.tableView.isScrollEnabled = !newValue
        }
    }
    
    var mainBgColor: UIColor {
        return UIColor.lightGray
    }
    
    /// 刷新控件
    lazy var refreshView: RefreshView = {
        let view = RefreshView(frame: .init(x: 0, y: 0, width: 200, height: 49))
        view.centerX = self.tableView.centerX
        view.isHidden = true
        return view
    }()
    
    // 二楼容器
    lazy var secondFoorView: SecondFloorView = {
        let view = SecondFloorView.init(frame: .init(x: 0, y: 0, width: width, height: height))
        view.delegate = self
        return view
    }()
    
    // 主列表
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: .init(x: 0, y: 0, width: width, height: height))
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .clear
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.addViews()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.shakeViewUpDown(self.tableView)
        self.secondFoorView.navigationBar.tapActionHandler = { [weak self] in
            self?.anmationToFirstFloor()
        }
    }
    
    
    func addViews() {
        self.view.addSubview(self.secondFoorView)
        self.view.addSubview(self.tableView)
        self.view.bringSubviewToFront(self.tableView)
        self.tableView.addSubview(self.refreshView)
        self.view.backgroundColor = self.mainBgColor
    }
    
    
    func shakeViewUpDown(_ view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [-10, 10, -6, 6, -2, 2, 0]
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.layer.add(animation, forKey: "shake")
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row)"
        cell.backgroundColor = .red
        return cell
    }
}

extension ViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.doAnimation) {
            return
        }
        let y = scrollView.contentOffset.y
        if y < 0 {
            // 滑动距离
            let scrollDistance = abs(y)
            let ignoreDist: CGFloat = pullTriggerThreshold
            let loadingDistance = scrollDistance > ignoreDist ? scrollDistance - ignoreDist : 0
            // 计算动画百分比
            let percent = min(loadingDistance, secondFloorhreshold) / secondFloorhreshold
            
            // 透明度
            let alpha = 1 - percent
            
        
            
            if (scrollDistance > pullTriggerThreshold && scrollDistance < refreshThreshold) {
                refreshView.isHidden = false
                refreshView.setText(text: "下拉刷新")
                refreshView.updateProgressWithPercent(0.14)
            } else if (scrollDistance > refreshThreshold && scrollDistance < secondFloorhreshold) {
                refreshView.isHidden = false
                refreshView.setText(text: "松手刷新，继续下拉进二楼")
                refreshView.updateProgressWithPercent(percent)
            } else if (scrollDistance > secondFloorhreshold) {
                refreshView.isHidden = false
                refreshView.setText(text: "松手进二楼")
                refreshView.updateProgressWithPercent(1)
            } else {
                refreshView.isHidden = true
            }
            self.secondFoorView.transformWithPercent(percent / 5)

        }
    }
    
    // 即将开始拖动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }

    // 即将停止拖动
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let y = scrollView.contentOffset.y
        if (y <= -secondFloorhreshold) {
            AudioServicesPlaySystemSound(1520)
            self.anmationToSecondFloor()
        } else if (y > -secondFloorhreshold && y <= -refreshThreshold) {
            print("松手刷新")
        }
    }
}


extension ViewController {
    
    
    /// 进入二楼动画
    func anmationToSecondFloor() {
        print("-------------->进入二楼")
        self.doAnimation = true
        UIView.animate(withDuration: animationTimeinterval) {
            self.tableView.frame = .init(x: 0, y:  self.height, width: self.width, height: self.height)
            self.secondFoorView.transformWithPercent(1)
        } completion: { _ in
        }
    }
    
    
    /// 进入一楼动画
    func anmationToFirstFloor() {
        print("---------------->回到一楼")
        self.refreshView.isHidden = true
        self.secondFoorView.dismissViewWithAnimation()
        UIView.animate(withDuration: animationTimeinterval) {
            self.tableView.scrollsToTop = true
            self.tableView.frame = .init(x: 0, y: 0, width: self.width, height: self.height)
            self.tableView.isScrollEnabled = true
        } completion: { _ in
            self.doAnimation = false
        }
    }
    
    
}

extension ViewController: SecondFloorDidScrollDelegate {

    func secondFloorViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let currentOffset = offset.y + bounds.size.height - inset.bottom
        let maximumOffset = size.height > bounds.height ? size.height : bounds.height
        if (currentOffset >= maximumOffset + 44 && !scrollView.isTracking) {
            self.anmationToFirstFloor()
        }
    }
}

