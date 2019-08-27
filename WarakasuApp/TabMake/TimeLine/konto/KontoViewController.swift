//
//  KontoViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/23.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import FirebaseFirestore

class KontoViewController: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource{
    
    // インスタンス化
    let db = Firestore.firestore()
    
    // 更新のぐるぐる
    let refreshControl = UIRefreshControl()
    
    // テーブルヴュー
    @IBOutlet weak var tableView: UITableView!
    
    // 投稿内容を格納する
    var items = [NSDictionary]()
    
    // タブ名
    var itemInfo: IndicatorInfo = "ショートコント"
    
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
        db.collection("Conte").getDocuments() {(querySnapshot, err) in
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
    }
    
    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConteCell", for: indexPath)
        // 選択不可にする
        cell.selectionStyle = .none
        // itemsの中からindexpathのrow番目を取得
        let dict = items[(indexPath as NSIndexPath).row]
        // 表示情報　プロフィール情報　ユーザー名　投稿画像　コメント
        
        // プロフィール画像
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        // 画像情報
        if let profImage = dict["profileImage"] {
        // NSData型に変換
        let dataProfImage = NSData(base64Encoded: profImage as! String, options: .ignoreUnknownCharacters)
        // さらにUIImage型に変換
        let decadedProfImage = UIImage(data: dataProfImage! as Data)
        // profileImageViewへ代入
        profileImageView.image = decadedProfImage
            print ("通過しました")
        } else {
         profileImageView.image = #imageLiteral(resourceName: "宇宙人アイコン")
            print ("nilです")
        }
        
        // ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = dict["userName"] as? String
        
        // コメント
        let commentTextView = cell.viewWithTag(4) as! UILabel
        commentTextView.text = dict["comment"] as? String
        
        return cell
    }
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
    // IndicatorInfoProvider のクラスの中に書かないとダメなやつ
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }
}
