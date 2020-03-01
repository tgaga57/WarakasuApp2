//
//  TabBarController.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/23.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var userName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(userName)
        // Do any additional setup after loading the view.
    }

    func toseni() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Timeline") as! TimeLineViewController
       
    }
}
