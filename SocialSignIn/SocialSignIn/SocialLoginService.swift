//
//  SocialLoginService.swift
//  SocialSignIn
//
//  Created by Abhishek on 24/05/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit

public enum LINKED_IN: String {
    case Client_ID = "81zr1p90aql4b2"
    case Client_Secret = "x5YoR2crygiF6jTA"
    case AppID = "4994525"
    case Auth_EndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    case AcessToken_EndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
}

public class SocialLoginService: NSObject {

    public class func openURL(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
        if LISDKCallbackHandler.shouldHandle(url) {
            
            return LISDKCallbackHandler.application(application,
                                                    open: url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
        }
        
        return true
    }
    
//    public func createSession() {  // OT IS WHEN APP IS INSTALLED
//        
//        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION],
//                                          state: nil,
//                                          showGoToAppStoreDialog: true,
//                                          successBlock: { (returnState) in
//                                            
//                                            print("Return State \(String(describing: returnState))")
//                                            let session = LISDKSessionManager.sharedInstance().session
//                                            print("Session State: \(String(describing: session?.isValid()))")
//                                            print("Session Value: \(String(describing: session?.value()))")
//                                            print("Session Token: \(String(describing: session?.accessToken))")
//        }) { (error) in
//            print("Session error \(String(describing: error))")
//        }
//    }
    
    func requestForAccessToken(_ authorizationCode: String, completion : @escaping (_ accessToken: String) -> Void) {
        
        let grantType = "authorization_code"
        let redirectURL = "https://com.nickelfox.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
    
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(LINKED_IN.Client_ID.rawValue)&"
        postParams += "client_secret=\(LINKED_IN.Client_Secret.rawValue)"

        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: LINKED_IN.AcessToken_EndPoint.rawValue)!)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
      
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                
                do {
                    
                    let dictionary = try JSONSerialization.jsonObject(with: data!,
                                                                      options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    let accessToken = dictionary["access_token"] as! String
                    
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    completion(accessToken)
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        
        task.resume()
    }
    
    func startAuthorization(webView: UIWebView) {
        
        let responseType = "code"
        let redirectURL = "https://com.nickelfox.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        let scope = "r_basicprofile"
        
        var authorizationURL = "\(LINKED_IN.Auth_EndPoint.rawValue)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(LINKED_IN.Client_ID.rawValue)&"
        authorizationURL += "redirect_uri=\(redirectURL!)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print("AUTH_URL: \(authorizationURL)")
        
        guard let requestUrl = URL(string: authorizationURL) else { return }
        let request = URLRequest(url: requestUrl)
        webView.loadRequest(request)
    }
    
}
