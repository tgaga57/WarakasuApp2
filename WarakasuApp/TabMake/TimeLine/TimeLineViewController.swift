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
import FirebaseStorage
import AVFoundation

class TimeLineViewController: ButtonBarPagerTabStripViewController{
    
     // Firebaseで使用するパス
    let videoPath = "video"
    
    // firebase Storage
    let storage = Storage.storage()
    
    // firebase Firestore
    let db = Firestore.firestore()

    // 動画情報のリスト
    var videoList: [String] = []
    // avプレイヤーの情報
    var player = AVPlayer()
    // 再生したかどうか
    var isPlay: Bool = false
    //自分がどのタブにいるか
    
    
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
    
    // 投稿ボタン
    @IBAction func tappedPostButton(_ sender: Any) {
//        print(self.currentIndex)
        // 遷移処理
        let storyboard: UIStoryboard = UIStoryboard(name: "Post", bundle: nil)
        let PostViewController = storyboard.instantiateViewController(withIdentifier: "Post") as! PostViewController
        self.present(PostViewController, animated: true, completion: nil)
        
    }
  
}
