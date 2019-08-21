//
//  PostContentViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/21.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PostContentViewController: UIViewController, IndicatorInfoProvider {


    var itemInfo: IndicatorInfo = "Warakasu"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // IndicatorInfoProvider のクラスの中に書かないとダメなやつ
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }


}
