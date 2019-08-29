//
//  GyaguTableViewCell.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/28.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import FirebaseStorage
import AVFoundation
import AVKit
import Firebase

class GyaguTableViewCell: UITableViewCell {
    
    // firebase
    let db = Firestore.firestore()
    
    // items
    var item: NSDictionary?
    
    // likecount
    var likeCount: Int = 0
    
    // ストレージ使うときに必要
    let storage = Storage.storage()
    
    // likeしたのを格納するはこ
    var likeListItems = [NSDictionary]()
    
    // AVプレイヤー情報
    var player = AVPlayer()
    
    // 再生したか否か
    var isPlay: Bool = false
    
    // firebaseのコレクション名
    let videoPath: String = "Gyagu"
    
    // profimage
    @IBOutlet weak var profImageView: UIImageView!
    // usernamelabel
    @IBOutlet weak var userNameLabel: UILabel!
    // videolabel
    @IBOutlet weak var videoView: UIView!
    // 投稿者のラベル
    @IBOutlet weak var commentLabel: UILabel!
    // いいね数ラベル
    @IBOutlet weak var likeLabel: UILabel!
    // お笑いラベル
    @IBOutlet weak var owaraiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // セル内のコメント、名前、写真、動画が反映
    func set(dict: NSDictionary) {
        commentLabel.text = dict["comment"] as? String
        videoPlay(filename: dict["filename"] as! String)
        userNameLabel.text = dict["userName"] as? String
        
        // 画像情報
        let profImage = dict["profileImage"]
        // NSData型に変換
        let dataProfImage = NSData(base64Encoded: profImage as! String, options: .ignoreUnknownCharacters)
        // さらにUIImage型に変換
        let decadedProfImage = UIImage(data: dataProfImage! as Data)
        // profileImageViewへ代入
        profImageView.image = decadedProfImage
    }
    
    // start button
    @IBAction func videoStartButton(_ sender: Any) {
        self.player.play()
    }
    
    // stop button
    @IBAction func videoStopButton(_ sender: Any) {
        self.player.pause()
    }
    
    // likebutton
    @IBAction func likeButton(_ sender: UIButton) {
        
        // likecountに足していく
        likeCount = likeCount + 1
        // likelabelにいいね数を表示
        // labalに表示できるようにString型に変更
        likeLabel.text = String(likeCount)
        
        switch likeCount {
        case (1...5):
            owaraiLabel.text = "まだまだ"
        case (3...20):
            owaraiLabel.text = "まあおもろい"
        case (21...50):
            owaraiLabel.text = "おもろい"
        case (51...100):
            owaraiLabel.text = "めちゃおもろい"
        case (100...200):
            owaraiLabel.text = "クソおもろい"
        case (200...1000):
            owaraiLabel.text = "神"
        default: break
        }
        
        // likelistの箱に入れていく
        // 名前
        let likeUserName = userNameLabel.text
        // 投稿文
        let likeComment = commentLabel.text
        // プロフィール画像
        var likeUserImage: NSData = NSData()
        if let iconImage = profImageView.image {
            likeUserImage = iconImage.jpegData(compressionQuality: 0.1)! as NSData
        }
        let base64IconImage = likeUserImage.base64EncodedString(options: .lineLength64Characters) as String
        
        // likeListを入れる
        
        let goodList: NSDictionary = ["likeName": likeUserName ?? "", "likeComment": likeComment ?? "","likeUserImage": base64IconImage,"createdAt": Timestamp(date: Date())]
        // firebaseにgoodListの情報を保存する
        db.collection("likeContents").addDocument(data: goodList as! [String : Any])
        print("いいね押されたよ")
    }
    
    
    func videoPlay(filename: String) {
        let storageRef = storage.reference()
        // ファイル名の一覧は取得できないので登録時に別途名前のリストをDBに作成しておくと良い。
        let starsRef = storageRef.child("\(videoPath)/\(filename)") // gs://test-video-d407d.appspot.com/video.mp4
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
                // 動画はポーズで出させる！
                self.player.pause()
                
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
}
