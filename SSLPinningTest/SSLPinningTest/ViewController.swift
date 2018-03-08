//
//  ViewController.swift
//  SSLPinningTest
//
//  Created by Fan on 2018/3/7.
//  Copyright © 2018年 Luke. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDelegate, URLSessionTaskDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //urlSession(<#T##session: URLSession##URLSession#>, didReceive: <#T##URLAuthenticationChallenge#>, completionHandler: <#T##(URLSession.AuthChallengeDisposition, URLCredential?) -> Void#>)
        if let url = NSURL(string: "https://lovepay.kgibank.com") {
            
            
            let session = URLSession(
                configuration: URLSessionConfiguration.ephemeral,
                delegate: NSURLSessionPinningDelegate() as URLSessionDelegate,
                delegateQueue: nil)
            
            
            let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("error: \(error!.localizedDescription): \(error!)")
                } else if data != nil {
                    if let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                        print("Received data:\n\(str)")
                    }
                    else {
                        print("Unable to convert data to text")
                    }
                }
            })
            
            task.resume()
        }
        else {
            print("Unable to create NSURL")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

