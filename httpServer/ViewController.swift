//
import UIKit
import WebKit
import Swifter

extension FileManager {
    func listFiles(path: String) -> [URL] {
        let baseurl: URL = URL(fileURLWithPath: path)
        var urls = [URL]()
        enumerator(atPath: path)?.forEach({ (e) in
            guard let s = e as? String else { return }
            let relativeURL = URL(fileURLWithPath: s, relativeTo: baseurl)
            let url = relativeURL.absoluteURL
            
            urls.append(url)
        })
        return urls
    }
}

extension URL {
    func subDirectories() throws -> [URL] {
        print("contentsOfDir \(self)")
        // @available(macOS 10.11, iOS 9.0, *)
        guard hasDirectoryPath else { return [] }
        return try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter(\.hasDirectoryPath)
    }
}

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let distDir = Bundle.main.url(forResource: "dist", withExtension: nil)
        let server = HttpServer()
        server["/:path"] = shareFilesFromDirectory(distDir!.path)//String(distDir))
        print("distDir = \(distDir)")
        do {
            let subDirs = try distDir?.subDirectories()
            print("subDirs + \(subDirs)")
            for dir in subDirs ?? [] {
                let relativePath = dir.absoluteString[distDir!.absoluteString.endIndex ..< dir.absoluteString.endIndex]
                print("relativePath \(relativePath)")
                server["/\(relativePath)/:path"] = shareFilesFromDirectory(String("\(dir.path)"))
            }
        } catch {
            print(error)
        }
            
        
//        server["/assets/:path"] = shareFilesFromDirectory(String(distDir!.path+"/assets"))
//        server["/01head/:path"] = shareFilesFromDirectory(String(distDir!.path+"/01head"))
//        server["/03value/:path"] = shareFilesFromDirectory(String(distDir!.path+"/03value"))
//        server["/04create/:path"] = shareFilesFromDirectory(String(distDir!.path+"/04create"))

        
            do {
                try
                server.start(8080)
                print(server)
                webView.load(URLRequest(url: URL(string: "http://127.0.0.1:8080/index.html")!))
                
            }
        catch {
print(error)
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

