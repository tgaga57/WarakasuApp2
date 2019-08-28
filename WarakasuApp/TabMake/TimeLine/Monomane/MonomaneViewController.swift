//
//  MonomaneViewController.swift
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

class MonomaneViewController: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource{
    // インスタンス化
    let db = Firestore.firestore()
    // 更新のぐるぐる
    let refreshControl = UIRefreshControl()
    
    // firebase Storage
    let storage = Storage.storage()
    
    // tableview
    @IBOutlet weak var tableView: UITableView!
    
    // 投稿内容を格納する
    var items = [NSDictionary]()
    
    // 動画情報のリスト
    var videoList: [String] = []
    
    // タブ名
    var itemInfo: IndicatorInfo = "モノマネ"
    
    // 動画のフォルダ名
    let videoPath: String = "Imitation"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // refreshControlに文言を追加
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        // アクションを指定
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // テーブルビューに追加
        tableView.addSubview(refreshControl)
        
        // tableViewのデリゲート接続
        tableView.delegate = self
        tableView.dataSource = self
        
        fetch()
        
    }
    
    // データの取得
    func fetch() {
        // getで一発ギャグのコレクションを取得
        db.collection("Imitation").getDocuments() {(querySnapshot, err) in
            // tempItemsという変数を一時的に作成
            var tempItems = [NSDictionary]()
            // for文で回し`item`に格納
            for item in querySnapshot!.documents {
                // item内のデータをdictという変数に入れる
                let dict = item.data()
                // dictをtempItemsに入れる
                tempItems.append(dict as NSDictionary)
            }
            // tempItemsをitems(クラスの変数として定義した)に入れる
            self.items = tempItems
            // リロード
            self.tableView.reloadData()
        }
    }
    
    // 更新
    @objc func refresh() {
        // 初期化
        items = [NSDictionary]()
        // 情報を取得
        fetch()
        // tableViewをリロード
        tableView.reloadData()
        // リフレッシュを止める
        refreshControl.endRefreshing()
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数は投稿情報の数
        return items.count
//        return 1
    }
    
    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImitationCell", for: indexPath) as! MonomaneTableViewCell
        // 選択不可にする
        cell.selectionStyle = .none

        // itemsの中からindexpathのrow番目を取得
        let dict = items[(indexPath as NSIndexPath).row]
        
        // cellviewcontloorに飛ばす
        cell.set(dict: dict)
     
        return cell
    }
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    // IndicatorInfoProvider のクラスの中に書かないとダメなやつ
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }
}
