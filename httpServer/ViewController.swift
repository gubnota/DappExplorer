//
import UIKit
import WebKit
import Swifter

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let indexURL = Bundle.main.url(forResource: "seer_dao", withExtension: "html",subdirectory: "dist"){
        let indexPath = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "dist")!
//        if         {
            let start = indexPath.index(indexPath.startIndex, offsetBy: 0)
            let end = indexPath.index(indexPath.endIndex, offsetBy: -10)
            let range = start..<end
            let distDir = indexPath[range]// remove index.html at the end
            
            let server = HttpServer()
            
            server["/:path"] = shareFilesFromDirectory(String(distDir))
        server["/assets/:path"] = shareFilesFromDirectory(String(distDir+"/assets"))
        server["/01head/:path"] = shareFilesFromDirectory(String(distDir+"/01head"))
        server["/03value/:path"] = shareFilesFromDirectory(String(distDir+"/03value"))
        server["/04create/:path"] = shareFilesFromDirectory(String(distDir+"/04create"))

        
            do {
                try
                server.start(8080)
                print(server)
                webView.load(URLRequest(url: URL(string: "http://127.0.0.1:8080/index.html")!))
            }
        catch {
print("err")
            }

//            webView.loadFileURL(indexURL, allowingReadAccessTo: indexURL)
//                    }
//        else {
//                    let url = URL(string: "https://www.baidu.com")!
//                    webView.load(URLRequest(url: url))
//        webView.loadHTMLString("<html><body><h1>Hello, translocation</h1></body></html>", baseURL:URL(string: "https://www.baidu.com"))
//        }
        webView.allowsBackForwardNavigationGestures = true

    }


}

