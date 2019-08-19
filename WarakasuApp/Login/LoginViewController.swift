//
//  LoginViewController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/19.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import TransitionButton
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // メールアドレス
    @IBOutlet weak var emailTextFiled: UITextField!
    
    // パスワード
    @IBOutlet weak var passWordTextfiled: UITextField!
    
    // 新規登録ボタン
    @IBAction func newMember(_ sender: TransitionButton) {
        //emailとパスワードにnilが入っていないかを確認
        guard let email = emailTextFiled.text, let password = passWordTextfiled.text else {
            return
        }
        sender.startAnimation()
        // firebaseAuthの新規登録処理
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.showErrorAlert(error: error)
                // 認証失敗
                print("新規作成失敗")
                sender.stopAnimation()
            } else {
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                
                backgroundQueue.async {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        sender.stopAnimation(animationStyle: .expand, completion: {
                            // 認証成功
                            print("新規作成成功")
                            UserDefaults.standard.set("check", forKey: "set")
                            self.toTimeLine()
                        })
                    })
                }
            }
        })
    }
    
    
    // ログインボタン
    @IBAction func loginbutton(_ sender: TransitionButton) {
        //emailとパスワードにnilが入っていないかを確認
        guard let email = emailTextFiled.text, let password = passWordTextfiled.text else {
            return
        }
        
        sender.startAnimation()
        
        // ログイン処理
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.showErrorAlert(error: error)
                // 認証の失敗
                print("ログイン失敗")
                sender.stopAnimation()
            } else {
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                
                backgroundQueue.async {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        sender.stopAnimation(animationStyle: .expand, completion: {
                            // 成功
                            print("ログイン成功")
                            UserDefaults.standard.set("check", forKey: "set")
                             // タイムラインへ遷移
                            self.toTimeLine()
                        })
                    })
                }
            }
        })
    }
    
    func toTimeLine() {
        // storyboardのfileの特定
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // 移動先のvcをインスタンス化
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        // 遷移処理
        self.present(vc, animated: true)
    }
    
    // エラーが返ってきた場合のアラート
    func showErrorAlert(error: Error?)  {
        let alert = UIAlertController(title: "エラー", message: "error?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        // 表示
        self.present(alert, animated: true)
    }
    
    // キーボードを閉じる処理
    // 画面が触られたかを判断
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードが開いていたら
        if emailTextFiled.isFirstResponder {
            // 閉じます
            emailTextFiled.resignFirstResponder()
        } // パスワードも閉じます
        if passWordTextfiled.isFirstResponder {
          passWordTextfiled.resignFirstResponder()
        }
    }
    }
