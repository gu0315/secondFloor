//
//  Config.swift
//  WeChat
//
//  Created by 顾钱想 on 2023/6/28.
//

import UIKit

/// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height
/// 主色调
let primaryColor: UIColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)

/// 小球从显示到放大小球的临界点
let criticalPoint0: CGFloat = 80
/// 小球从放大到扩散的临界点
let criticalPoint1: CGFloat = 120
/// 小球从扩散到平移的临界点
let criticalPoint2: CGFloat = 160
/// 小球消失的临界点
let criticalPoint3: CGFloat = 200



