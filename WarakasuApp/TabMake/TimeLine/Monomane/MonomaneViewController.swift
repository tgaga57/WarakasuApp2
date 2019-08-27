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
    
    // 動画が反映されるやつ
    @IBOutlet weak var videoView: UIView!
    // AVプレイヤー情報
    var player = AVPlayer()
    // 再生したか否か
    var isPlay: Bool = false
    
    // 投稿内容を格納する
    var items = [NSDictionary]()
    
    // 動画情報のリスト
    var videoList: [String] = []
    // firebaseのストレージ名
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
    
    /// Firestoreに別途格納した動画名の一覧を取得する
    func fetchList() {
        db.collection(videoPath).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    guard let names = document.data() as? [String: String], let name = names["name"] else {
                        return
                    }
                    
                    self.videoList.append(name)
                }
                print(self.videoList)
                self.tableView.reloadData()
            }
        }
    }
    
    // 動画の再生と破棄を行う
    func videoPlay(index: Int) {
        let storageRef = storage.reference()
        // ファイル名の一覧は取得できないので登録時に別途名前のリストをDBに作成しておくと良い。
        let starsRef = storageRef.child("\(videoPath)/\(videoList[index])") // gs://test-video-d407d.appspot.com/video.mp4
        print("starsRef:\(starsRef)")
        
        // ダウンロードURLの生成
        starsRef.downloadURL { url, error in
            if let error = error {
                print("取得エラー:\(error)")
                
            } else {
                guard let url = url else {
                    print("動画変換失敗")
                    return
                }
                print("url:\(url)")
                // Bundle Resourcesからsample.mp4を読み込んで再生
                self.player = AVPlayer(url: url)
                self.player.play()
                
                if !self.isPlay {
                    self.isPlay = true
                    // AVPlayer用のLayerを生成
                    let playerLayer = AVPlayerLayer(player: self.player)
                    playerLayer.frame = self.videoView.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    playerLayer.zPosition = -1 // ボタン等よりも後ろに表示
                    self.videoView.layer.insertSublayer(playerLayer, at: 0) // 動画をレイヤーとして追加
                    
                } else {
                    if let layer = self.videoView.layer.sublayers?.first {
                        layer.removeFromSuperlayer() //Superlayerから取り除く
                    }
                    let playerLayer = AVPlayerLayer(player: self.player)
                    playerLayer.frame = self.videoView.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    playerLayer.zPosition = -1 // ボタン等よりも後ろに表示
                    self.videoView.layer.insertSublayer(playerLayer, at: 0) // 動画をレイヤーとして追加
                }
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImitationCell", for: indexPath)
        // 選択不可にする
        cell.selectionStyle = .none
        // itemsの中からindexpathのrow番目を取得
        let dict = items[(indexPath as NSIndexPath).row]
        
        // 表示情報。プロフィール情報、ユーザー名、投稿画像、コメント
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
