//
//  GyaguViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/23.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class GyaguViewController: UIViewController,IndicatorInfoProvider{
    // タブ名
    var itemInfo: IndicatorInfo = "一発ギャグ"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        // IndicatorInfoProvider のクラスの中に書かないとダメなやつ
        func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            
            return itemInfo
    }
}
