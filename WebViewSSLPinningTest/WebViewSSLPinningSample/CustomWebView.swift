//
//  CustomWebView.swift
//  WebViewSSLPinningTest
//
//  Created by Fan on 2018/3/6.
//  Copyright © 2018年 Luke. All rights reserved.
//

import WebKit

public class CustomWebView: WKWebView {
    
    // var javascript: Javascript!
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        super.init(frame: frame, configuration: configuration)
        doInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doInit() {
        //clearCache()
        //self.javascript = Javascript(webView: self)
        self.allowsBackForwardNavigationGestures = true
        self.navigationDelegate = self
        self.uiDelegate = self
        self.scrollView.delegate = self
    }
    
}

extension CustomWebView : WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation){
        print("didStartProvisionalNavigation")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    /// Handle SSL connections by default. We aren't doing SSL pinning or custom certificate handling.
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("didReceive challenge")
        
        //check CN
        let whiteStaticList = ["https://lovepay.kgibank.com",]
        let whiteList = whiteStaticList.filter { challenge.protectionSpace.host.hasPrefix($0) }
        print("WhiteList: \(whiteList.count)")
        if whiteList.count > 0 {
            //print("WhiteList: \(whiteList[1,2])")
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:challenge.protectionSpace.serverTrust!))
            return
        }
        
        /**
         * We started listening to this delegate method to avoid of `SSL Pinning`
         * and `man-in-the-middle` attacks. Is required have certificate in
         * local project e.g. `example.com.der`
         */
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                if(errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let cert1 = NSData(bytes: data, length: size)
                        print(cert1)
                        let file_der = Bundle.main.path(forResource: "kgibank", ofType: "der")
                        print("certificate file is empyty: \(file_der?.isEmpty)")
                        if let file = file_der {
                            if let cert2 = NSData(contentsOfFile: file) {
                                print(cert2)
                                if cert1.isEqual(to: cert2 as Data) {
                                    print("pinning Susscess")
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        //Pinning failed
        print("Pinnng failed")
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("Error 'didFail': \(error.localizedDescription)\nSchema: \(String(describing: webView.url?.absoluteString))")
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("Error 'didFailProvisionalNavigation': \(error.localizedDescription)\nSchema: \(String(describing: webView.url?.absoluteString))")
    }
    
    // Called when js need open _blank link
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let url = navigationAction.request.url
            if url?.description.lowercased().hasPrefix("http://") != nil ||
                url?.description.lowercased().hasPrefix("https://") != nil ||
                url?.description.lowercased().hasPrefix("mailto:") != nil  {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                // Only Use at iOS 9.
                //UIApplication.shared.openURL(url!)
            }
        }
        return nil
    }
    
    
    // MARK: - Scrollview Delegate
    
    // keeps the page from scrolling horizontally
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            var offset = scrollView.contentOffset
            offset.x = 0
            scrollView.contentOffset = offset
        }
    }
    
    // Disables zooming
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
}

extension WKWebView {
    public func constraint(toView contentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
