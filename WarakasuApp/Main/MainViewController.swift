//
//  ViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/19.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainViewController: BarPagerTabStripViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 管理されるviewCintrollerを返す処理
        // タイムライン
        let TimeLineVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeLine")
        //  投稿
         let PostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Post")
        // 検索
        let SearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Search")
        // 自分のプロフィール
         let ProfVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Profile")
        
        // childViewControllersを配列でVCを入れる
        let childViewControllers:[UIViewController] = [TimeLineVC, PostVC, SearchVC, ProfVC]
        
        return childViewControllers
    }
    
}

