//
//  PostCell.swift
//  fotogma
//
//  Created by 장창순 on 2016. 3. 3..
//  Copyright © 2016년 fotogma. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {

    @IBOutlet var postedImg: UIImageView!
    @IBOutlet var postText: UILabel!
    @IBOutlet var heartImg: UIButton!
    @IBOutlet var numberOfLikes: UILabel!
    
    var post: Post!
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post, img: UIImage?) {
        
        self.post = post
        self.postText.text = post.postDescription
        self.numberOfLikes.text = "\(post.likes)"
        self.postedImg.hidden = false
        
        
        if post.imageUrl != nil {
            if img != nil {
                self.postedImg.image = img
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data , err in
                if err == nil
                {
                    let img = UIImage(data: data!)!
                    self.postedImg.image = img
                    FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                
                })
            }
        } else {
            self.postedImg.hidden = true
        }
    }

    
    
}
