//
//  ViewController.swift
//  SocialSignIn
//
//  Created by Abhishek on 24/05/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(_ sender: Any) {
        
        let vc = UIStoryboard.initVC(id: "LIWebViewController")
        self.present(vc, animated: true, completion: nil)
    }

}

extension UIStoryboard {
    
    class func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func initVC(id: String) -> UIViewController {
        return getStoryboard().instantiateViewController(withIdentifier: id)
    }
}

extension UIImageView {
    
    func downloadImage(from url: String) {
        if let webUrl = URL(string: url) {
            let urlRequest = URLRequest(url: webUrl)
            let task = URLSession.shared.dataTask(with: urlRequest)  { (imgData, responce, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
}
