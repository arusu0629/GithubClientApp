//
//  WebViewController.swift
//  GithubClient
//
//  Created by Toru Nakandakari on 2020/02/24.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let webView = WKWebView()
    var requestUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // webViewの大きさを画面全体にして表示
        webView.frame = view.frame
        view.addSubview(webView)

        // URLを指定してロードする
        let url = URL(string: requestUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}
