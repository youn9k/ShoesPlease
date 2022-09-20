//
//  MyWebView.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/28.
//

import SwiftUI
import WebKit

struct MyWebView: View {
    var urlToLoad: String
    @State var workState = WebView.WorkState.initial

    var body: some View {
        ZStack {
            WebView(urlToLoad: urlToLoad, workState: self.$workState)
            if workState == .working {
                ProgressView("")
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(1.3, anchor: .top)
                    .padding()
                    .frame(height: 30)
                    .transition(.move(edge: .top).animation(.easeInOut).combined(with: .opacity))
            }
            
        }
    }
}

struct WebView: UIViewRepresentable {
    enum WorkState: String {
            case initial
            case done
            case working
            case errorOccurred
        }

        let urlToLoad: String
        @Binding var workState: WorkState

        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            return webView
        }

        func updateUIView(_ uiView: WKWebView, context: Context) {
            switch self.workState {
            case .initial:
                if let url = URL(string: self.urlToLoad) {
                    uiView.load(URLRequest(url: url))
                }
            default:
                break
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: WebView

            func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
              self.parent.workState = .working
            }

            func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
                self.parent.workState = .errorOccurred
            }

            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                self.parent.workState = .done
            }

            init(_ parent: WebView) {
                self.parent = parent
            }
        }
}
 
//Canvas 미리보기용
struct MyWebView_Previews: PreviewProvider {
    static var previews: some View {
        MyWebView(urlToLoad: "https://www.naver.com")
    }
}
