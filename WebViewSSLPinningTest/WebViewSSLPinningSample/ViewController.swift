//
//  ViewController.swift
//  WebViewSSLPinningTest
//
//  Created by Fan on 2018/3/6.
//  Copyright © 2018年 Luke. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var view_Web: UIView!
    
    var webView: CustomWebView! //The WKWebView we'll use.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initControls()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func connect_Button(_ sender: Any) {
        var request = URLRequest(url: URL(string: "about:blank")!)
        request = URLRequest(url: URL(string: "https://lovepay.kgibank.com")!)
        webView.load(request)
        webView.navigationDelegate = webView
        webView.uiDelegate = webView
    }
    
    func initControls(){
        
        //WKUserContentController allows us to add Javascript scripts to our webView that will run either at the beginning of a page load OR at the end of a page load.

        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        configuration.userContentController = contentController
        
        webView = CustomWebView(frame: view.frame, configuration: configuration)
        view_Web.addSubview(webView)
       
        //addJSPlugin(["Console"])
        
    }


}

