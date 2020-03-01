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
    
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.white
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1)
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
        PostViewController.modalPresentationStyle = .fullScreen
        // タブのカテゴリーのidを渡す！　0＝一発ギャグ １＝ コント 2＝モノマネ
        PostViewController.categoryId = currentIndex
        self.present(PostViewController, animated: true, completion: nil)
        
    }
    
}
