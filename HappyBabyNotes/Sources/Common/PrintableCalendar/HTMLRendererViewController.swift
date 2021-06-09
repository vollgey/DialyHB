//
//  CalendarHTMLRenderer.swift
//  HPBCalendar
//
//  Created by BadApple on 2019/04/12.
//  Copyright © 2019 Studio9. All rights reserved.
//

import WebKit

class HTMLRendererViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    let html: String
    let cssURL = Bundle.main.url(forResource: "style", withExtension: "css")!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(html: String) {
        print("init called")
        self.html = html

        super.init(nibName: nil, bundle: nil)

        self.loadViewIfNeeded()

        let rootVC = UIApplication.shared.keyWindow!.rootViewController!
        rootVC.addChild(self)
        self.didMove(toParent: rootVC)
        print("init executed")
    }

    deinit {
        print("deinitted")
    }

    override func loadView() {
        print("loadView started")
        super.loadView()

        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 2247 / 2, height: 1682 / 2))
        webView.navigationDelegate = self
        self.view = self.webView

        self.view.isHidden = true

        print("loadView executed")
    }

    func render() {
        print("draw started")
        self.webView.loadHTMLString(self.html, baseURL: self.cssURL)
        print("draw executed")
    }

    // 描画delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView did finish delegate called")
        webView.takeSnapshot(with: nil) { image, _ in
            print("takeSnapshot called")

            // documentに保存(デバッグ用)
            let dir = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
            let filepath = dir.appendingPathComponent("test.png")
            print(filepath)
            let data = image!.pngData()!
            try! data.write(to: filepath)

            // 写真ライブラにに保存
            if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }

            // デイニシャライズに必要な処理
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            print("takeSnapshot executed")
        }

        print("webView did finish delegate executed")
    }
}
