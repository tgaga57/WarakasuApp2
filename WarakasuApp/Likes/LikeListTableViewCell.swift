//
//  LikeListTableViewCell.swift
//  WarakasuApp
//
//  Created by 志賀大河 on 2019/08/29.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit

class LikeListTableViewCell: UITableViewCell {
    
    // item
    var item: NSDictionary?
    
    // likeuserimage
    @IBOutlet weak var likeuserImage: UIImageView!
    // likeusername
    @IBOutlet weak var likeUserName: UILabel!
    // likecomment
    @IBOutlet weak var likeComment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // firwbaseから取り出す
    func set(dict: NSDictionary) {
        
        likeComment.text = dict["likeComment"] as? String
        likeUserName.text = dict["likeName"] as? String
        // 画像情報
        let profImage = dict["likeUserImage"]
        // NSData型に変換
        let dataProfImage = NSData(base64Encoded: profImage as! String, options: .ignoreUnknownCharacters)
        // さらにUIImage型に変換
        let decadedProfImage = UIImage(data: dataProfImage! as Data)
        // profileImageViewへ代入
        likeuserImage.image = decadedProfImage
    }
}
