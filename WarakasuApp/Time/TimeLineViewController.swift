//
//  TimeLineViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/23.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TimeLineViewController: ButtonBarPagerTabStripViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 管理されるviewCintrollerを返す処理
        // 一発ギャグ
        let GyaguVC = UIStoryboard(name: "Gyagu", bundle: nil).instantiateViewController(withIdentifier: "Gyagu")
        // Konto
        let KontoVC = UIStoryboard(name: "Konto", bundle: nil).instantiateViewController(withIdentifier: "Konto")
        // モノマネ
        let MonomaneVC = UIStoryboard(name: "Monomane", bundle: nil).instantiateViewController(withIdentifier: "Monomane")
        // childViewControllersを配列でVCを入れる
        let childViewControllers:[UIViewController] = [GyaguVC, KontoVC, MonomaneVC,]
        
        return childViewControllers
    }
    

}
