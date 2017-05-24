//
//  LIWebViewController.swift
//  SocialSignIn
//
//  Created by Abhishek on 24/05/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit

class LIWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        SocialLoginService().startAuthorization(webView: webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func returnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LIWebViewController {

    // MARK: UIWebViewDelegate Functions
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
        print(url)
        
        if url.host == "com.nickelfox.linkedin.oauth" {
            if url.absoluteString.range(of: "code") != nil {
                // Extract the authorization code.
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let code = urlParts[1].components(separatedBy: "=")[1]
                
                SocialLoginService().requestForAccessToken(code, completion: { (accessToken) in
                    print("SUCESS ACCESSTOKEN:  \(accessToken)")
                    DispatchQueue.main.async{
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
        return true
    }

}
