//
//  TimeLineViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/23.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import FirebaseFirestore

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
    
    // 投稿画面へ移動するボタン
    @IBAction func tappedPostButton(_ sender: Any) {
        // print(self.currentIndex)
        // 遷移処理
        let storyboard: UIStoryboard = UIStoryboard(name: "Post", bundle: nil)
        let PostViewController = storyboard.instantiateViewController(withIdentifier: "Post") as! PostViewController
        // タブのカテゴリーのidを渡す！　0＝一発ギャグ １＝ コント 2＝モノマネ
        PostViewController.categoryId = currentIndex
        self.present(PostViewController, animated: true, completion: nil)
        
    }
    
}
