//
//  TabBarController.swift
//  WechatHome
//
//  Created by 顾钱想 on 2023/6/27.
//

import UIKit

protocol ShowTabBarDelegate {
    func showTabBar()
    func hiddenTabBar()
}

class TabBarController: UITabBarController, ShowTabBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBarItems()
        let homeVC = ViewController()
        homeVC.delegate = self
        self.viewControllers = [UINavigationController.init(rootViewController: homeVC), UIViewController(), UIViewController(), UIViewController()]
        self.viewControllers![0].tabBarItem.title = "微信"
    }
    
    func configureTabBarItems() {
        
        self.tabBar.tintColor = UIColor.black
        self.tabBar.barTintColor = UIColor.white
   
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundColor = UIColor.white
        
        let path = CGMutablePath()
        path.addRect(tabBar.bounds)
        self.tabBar.layer.shadowPath = path
        path.closeSubpath()
   
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.tabBar.layer.shadowOpacity = 0.05
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.clipsToBounds = false
    }
    
    func showTabBar() {
        self.tabBar.isHidden = false
    }
    
    func hiddenTabBar() {
        self.tabBar.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
