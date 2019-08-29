//
//  MypageViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/23.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import FirebaseAuth

class MypageViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // プロフィールイメージ
    @IBOutlet weak var profImageView: UIImageView!
    
    // 名前投稿用テキストフィールド
    @IBOutlet weak var userNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
        // Do any additional setup after loading the view.
    }
    
    // ローカル（スマホ）で持っているプロフィールを持ってくる
    func getProfile() {
        // 画像情報
        if let profImage = UserDefaults.standard.object(forKey: "profileImage") {
            // NSData型に変換
            let dataImage = NSData(base64Encoded: profImage as! String ,options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            
            // さらにUIImage型へ変換
            let decodedImage = UIImage(data: dataImage! as Data)
            // prfileImageViewへ代入
            profImageView.image = decodedImage
        } else {
            // なければアイコン画像をいれておく
            profImageView.image = #imageLiteral(resourceName: "宇宙人アイコン")
        }
        
        // 名前情報
        if let profName = UserDefaults.standard.object(forKey: "userName") as? String {
            // profileNameLabelへ代入
            userNameText.text = profName
        } else {
            // なければ匿名としておく
            userNameText.text = "匿名"
        }
    }
    
    // プロフ写真変更用アクション
    @IBAction func changeProfPhoto(_ sender: Any) {
        // アクションシート
        let alert = UIAlertController(title: "選択してください", message: nil, preferredStyle: .actionSheet)
        // カメラ機能
        let openCamera = UIAlertAction(title: "カメラ", style: .default, handler: {(action: UIAlertAction) in
            //カメラへの遷移処理をかく
            self.cameraAction(sourceType: .camera)
            
        })
        // アルバム
        let openPhotos = UIAlertAction(title: "アルバム", style: .default, handler: {(acion: UIAlertAction) in
            // アルバムへの遷移処理を書く
            self.cameraAction(sourceType: .photoLibrary)
        })
        // キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        // アラートの追加
        alert.addAction(openCamera)
        alert.addAction(openPhotos)
        alert.addAction(cancelAction)
        // 表示
        present(alert, animated: true)
    }
    
    // カメラ・フォトライブラリへの遷移処理
    func cameraAction(sourceType: UIImagePickerController.SourceType) {
        // カメラ・フォトライブラリが使用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            // インスタンス作成
            let cameraPicker = UIImagePickerController()
            // ソースタイプの代入
            cameraPicker.sourceType = sourceType
            // デリゲートの接続
            cameraPicker.delegate = self
            // 画面遷移
            self.present(cameraPicker, animated: true)
        }
    }
    
    // 画面選択後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        if let pickedImage = info[.originalImage] as? UIImage {
            // 画面サイズに合わせて
            profImageView.contentMode = .scaleToFill
            // プロフ画像に反映
            profImageView.image = pickedImage
        }
        // 画像がプロフに反映される
        picker.dismiss(animated: true)
    }
    
    // 決定ボタン
    @IBAction func save(_ sender: Any) {
        var data: NSData = NSData()
        // 写真の確認
        if let image = profImageView.image {
            // クオリティーを下げる
            data = image.jpegData(compressionQuality: 0.1)! as NSData
        }
        
        let base64String = data.base64EncodedString(options: .lineLength64Characters) as String
        
        let userName = userNameText.text
        
        // アプリの中に保存
        // プロフ画像の保存
        UserDefaults.standard.set(base64String, forKey: "profileImage")
        // ユーザー名の保存
        UserDefaults.standard.set(userName, forKey: "userName")
        
        
        // showalert
        let title = "プロフィールを変えました！"
        let message = "動画を投稿しよう！"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    // ログアウトボタン
    @IBAction func logout(_ sender: Any) {
        // ログアウト
        try! Auth.auth().signOut()
        // storyboardのfileの特定
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        // 遷移先のvcのインスタンス化
        let VC = storyboard.instantiateViewController(withIdentifier: "Login")
        // 遷移処理
        self.present(VC, animated: true)
    }
    
    // キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if userNameText.isFirstResponder {
            userNameText.resignFirstResponder()
        }
    }
    
}
