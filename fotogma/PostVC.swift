//
//  PostVC.swift
//  fotogma
//
//  Created by 장창순 on 2016. 3. 6..
//  Copyright © 2016년 fotogma. All rights reserved.
//

import UIKit
import Alamofire

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var pickedImg: UIImageView!
    
    @IBOutlet var textView: UITextView!
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        pickedImg.image = image
    }
    
    @IBAction func addImage(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func savePost(sender: AnyObject) {
        
        if let txt = textView.text where txt != "" {
            if let img = pickedImg.image {

                let urlStr = "https://api.imageshack.com/v2/images"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "Z3CFP2YM038c8573c03d8eafeac9c60c8ba9a552".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { MultipartFormData in
                    
                    //Z3CFP2YM038c8573c03d8eafeac9c60c8ba9a552
                    MultipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    MultipartFormData.appendBodyPart(data: keyData, name: "key")
                    MultipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                    }) { encodingResult in
                
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            
                            upload.responseJSON(completionHandler: { (response) in
                                if let info = response.result.value as? Dictionary<String, AnyObject> {
                               
                                    if let result = info["result"] as? Dictionary<String, AnyObject> {
                                        if let imgArray = result["images"] as? [Dictionary<String,AnyObject>] {
                                            print(imgArray)
                                        }
                                    }
                                }
                            })
                            case .Failure(let error):
                            print(error)
                        }
                }
            }
            else {
                self.postToFirebase(nil)
            }
     self.dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    func postToFirebase(imgUrl: String?) {
        var post: Dictionary<String, AnyObject> = [
            "description": textView.text!,
            "likes" : 0,
            
        ]
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
    }
}