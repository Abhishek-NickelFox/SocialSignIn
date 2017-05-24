//
//  UserProfileViewController.swift
//  SocialSignIn
//
//  Created by Abhishek on 24/05/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit

struct UserProfile {
    var firstName: String?
    var lastName: String?
    var imageUrl: String?
    var profileUrl: String?
}

class UserProfileViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocialLoginService().getUserProfile { (profile) in
            DispatchQueue.main.async {
                self.setProfile(profile: profile)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setProfile(profile: UserProfile) {
        
        nameLabel.text = profile.firstName! + " " + profile.lastName!
        imgView.downloadImage(from: profile.imageUrl!)
    }

}
