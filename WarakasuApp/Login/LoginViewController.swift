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
    @IBAction func newMember(_ sender: Any) {
        //emailとパスワードにnilが入っていないかを確認
        guard let email = emailTextFiled.text, let password = passWordTextfiled.text else {
            return
        }
        
        sender.startAnimation()
        
        // ログイン処理
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.showErrorAlert(error: error)
                sender.stopAnimation()
            } else {
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                
                backgroundQueue.async {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        sender.stopAnimation(animationStyle: .expand, completion: {
                            // 成功
                            UserDefaults.standard.set("check", forKey: "set")
                            self.toTimeLine()
                            //                            self.setupKobiraViewController()
                        })
                    })
                }
            }
        })
    }
    // サインイン
    @IBAction func loginbutton(_ sender: Any) {
        //emailとパスワードにnilが入っていないかを確認
        guard let email = emailTextFiled.text, let password = passWordTextfiled.text else {
            return
        }
        
        sender.startAnimation()
        
        // ログイン処理
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.showErrorAlert(error: error)
                sender.stopAnimation()
            } else {
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                
                backgroundQueue.async {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        sender.stopAnimation(animationStyle: .expand, completion: {
                            // 成功
                            UserDefaults.standard.set("check", forKey: "set")
                            self.toTimeLine()
                            //                            self.setupKobiraViewController()
                        })
                    })
                }
            }
        })
    }
    
    // エラーが返ってきた場合のアラーと
    func showErrorAlert(error: Error?)  {
        let alert = UIAlertController(title: "エラー", message: "error?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        // 表示
        self.present(alert, animated: true)
    }
    
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
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }

