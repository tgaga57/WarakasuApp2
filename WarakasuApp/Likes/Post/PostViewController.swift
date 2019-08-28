//
//  PostViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/25.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import AVFoundation

class PostViewController: UIViewController {
    
    // pickerで選択した写真
    var willPostImage: UIImage = UIImage()
    
    // Firebaseで使用するパス
    var videoPath = ""
    
    
    
    // firebase Storage
    let storage = Storage.storage()
    
    // firebase Firestore
    let db = Firestore.firestore()
    
    // 動画情報のリスト
    var videoList: [String] = []
    
    // AVプレイヤー情報
    var player = AVPlayer()
    
    // 再生したか否か
    var isPlay: Bool = false
    
    // タブの変数(タイムラインの)
    var categoryId: Int?
    
    //動画が投稿されたときに使われる変数
    var isSelect : Bool = false
    // 投稿した動画確認用
    @IBOutlet weak var videoView: UIImageView!
    
    // プロフィール画像
    @IBOutlet weak var profileImageView: UIImageView!
    
    // プロフィールの名前
    @IBOutlet weak var profileName: UILabel!
    
    // 動画内容のコメント
    @IBOutlet weak var commentTextView: UITextView!
    // filename
    var fileName: String?
    
    
    // viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfile()
        // 確認用
        print(categoryId!)
        
        // カテゴリーidによりこコレクションを振り分ける
        switch categoryId {
        // 0の場合は
        case 0 :
            videoPath = "Gyagu"
        // １の場合は
        case 1 :
            videoPath = "Conte"
        // ２の場合は
        case 2:
            videoPath = "Imitation"
        // デフォルト
        default:
            break
        }
        
        // videopathの確認
        print(videoPath)
    }
    
    // ローカルで持っているprofile情報を反映
    func getProfile() {
        // 画像情報
        if let profImage = UserDefaults.standard.object(forKey: "profileImage") {
            // NSData型に変換
            let dataImage = NSData(base64Encoded: profImage as! String, options: .ignoreUnknownCharacters)
            // さらにUIImage型に変換
            let decodedImage = UIImage(data: dataImage! as Data)
            // profileImageViewに代入
            profileImageView.image = decodedImage
        } else {
            // なければアイコン画像をいれておく
            profileImageView.image = #imageLiteral(resourceName: "宇宙人アイコン")
        }

        // 名前情報
        if let profName = UserDefaults.standard.object(forKey: "userName") as? String {
            // profileNameLabelへ代入
            profileName.text = profName
        } else {
            // なければ匿名としておく
            profileName.text = "匿名"
        }
    }
    
    // 動画を載せる＋ボタン
    @IBAction func UpVideo(_ sender: UIButton) {
        pickVideo()
       
    }
    
    func pickVideo() {
        print("UIBarButtonItem。カメラロールから動画を選択")
        // カメラ・フォトライブラリが使用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            // インスタンス化
            let videoPicker = UIImagePickerController()
            // ソースタイプの代入
            videoPicker.sourceType = .photoLibrary
            videoPicker.mediaTypes = ["public.movie"]
            // デリゲートの接続
            videoPicker.delegate = self
            // 画面遷移
            self.present(videoPicker, animated: true)
            
        }
    }
    
    // 投稿ボタン
    @IBAction func PostAll(_ sender: Any) {
        // ネーム
        let userName = profileName.text
        // コメント
        let comment = commentTextView.text
        // プロフィール画像
        var profileImageData: NSData = NSData()
        if let profileImage = profileImageView.image {
            profileImageData = profileImage.jpegData(compressionQuality: 0.1)! as NSData
        }
        let base64ProfileImage = profileImageData.base64EncodedString(options: .lineLength64Characters) as String
        
        // Firestoreに飛ばす箱を用意
        guard let fileName = self.fileName else { return }
        let user: NSDictionary = ["userName": userName ?? "" , "comment": comment ?? "","profileImage": base64ProfileImage, "filename": fileName,"createdAt": Timestamp(date: Date())]
        
        // コメントとかを別々のコレクションに分ける
        if categoryId == 0 {
            print("0")
            db.collection("Gyagu").addDocument(data: user as! [String : Any])
        } else if categoryId == 1 {
            print("1")
            db.collection("Conte").addDocument(data: user as! [String : Any])
        } else if categoryId == 2 {
            print("2")
            db.collection("Imitation").addDocument(data: user as! [String: Any])
        } else {
            print("エラー")
        }
        
        // 画面を消す
        self.dismiss(animated: true)
    }

    
    // タイムラインに戻るボタン
    @IBAction func Back(_ sender: Any) {
        // 前の画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    // アップロード
    func uploadVideo(url: URL, fileName: String) {
        let storageRef = storage.reference()
        let starsRef = storageRef.child("\(videoPath)/\(fileName)")
        
        starsRef.putFile(from: url, metadata: nil) { metadata, error in
            starsRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("downloadURL:失敗)")
                    return
                }
                print("downloadURL:\(downloadURL)")
                // 名前情報を登録
                self.uploadVideoName(videoName: fileName)
            }
        }
    }
    
    // アップロードした動画名をDBに保存
    func uploadVideoName(videoName: String) {
        self.fileName = videoName
    }
    
    // キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if commentTextView.isFirstResponder {
            commentTextView.resignFirstResponder()
        }
    }
}

extension PostViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // ピッカーで動画が選択された
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let videoURL = info[.mediaURL] as? URL else {
            print("選択後のビデオパス取得できず。")
            return
        }
        
            let filename = videoURL.lastPathComponent
            print(videoURL)
            print(filename)
            uploadVideo(url: videoURL, fileName: filename)
            picker.dismiss(animated: true, completion: nil)
        
    }
    
}

