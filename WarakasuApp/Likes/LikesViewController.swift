//
//  LikesViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/23.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LikesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    // 更新のぐるぐる
    let refreshControl = UIRefreshControl()
    
    // いいねした投稿情報
    var likeContents = [NSDictionary]()
    
    // Firestoreをインスタンス化
    let db = Firestore.firestore()
    
    // tableview
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // firebaseから情報を取ってくる
        fetch()
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    // データの取得
    func fetch() {
        // getで一発ギャグのコレクションを取得
        db.collection("likeContents").order(by: "createdAt",descending: true).getDocuments() {(querySnapshot, err) in
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
        self.likeContents = tempItems
        // リロード
        self.tableView.reloadData()
    }
}
    
    // 更新
    @objc func refresh() {
        // 初期化
        likeContents = [NSDictionary]()
        // 情報を取得
        fetch()
        // tableViewをリロード
        tableView.reloadData()
        // リフレッシュを止める
        refreshControl.endRefreshing()
        
    }
    

// セクションの中のセルの数
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 投稿情報の数に設定
    return likeContents.count
}

// セルの設定
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LikeList", for: indexPath) as! LikeListTableViewCell
    
    // セルを選択不可にする
    cell.selectionStyle = .none
    
    let dict = likeContents[(indexPath as NSIndexPath).row]
    // 
    cell.set(dict: dict)
    
    
//    // プロフィール画像情報
//    if let profImage = dict["likeUserImage"] {
//        // NSData型に変換
//        let dataProfImage = NSData(base64Encoded: profImage as! String, options: .ignoreUnknownCharacters)
//        // さらにUIImage型に変換
//        let decadedProfImage = UIImage(data: dataProfImage! as Data)
//        // 代入
//        cell.likeuserImage.image = decadedProfImage
//    } else {
//
//        cell.likeuserImage.image = #imageLiteral(resourceName: "宇宙人アイコン")
//    }
//
//    // 名前を反映
//    cell.likeUserName.text = dict["likeUserName"] as? String
//
//    // ③投稿文反映
//    if let comment = dict["likeComment"] as? String {
//        cell.likeComment.text = comment
//    } else {
//        cell.likeComment.text = ""
//    }
//
    return cell
}
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
