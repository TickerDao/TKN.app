import SwiftUI
import WebKit
import UIKit

struct SearchView: View {
    @State private var textFieldText = ""
    @State private var webViewURL: URL?
    @State private var isFirstResponder = true
    @State private var searchHistory: [String] = []
        
    @State private var reloadWebView = false

    init() {
        webViewURL = nil
    }
    
    private func resetViewState() {
        textFieldText = ""
        webViewURL = nil
        isFirstResponder = true
    }
    
    private func saveSearchHistory(_ history: [String]) {
        if let encodedData = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encodedData, forKey: "searchHistory")
        }
    }
    
    private func loadSearchHistory() -> [String] {
        if let data = UserDefaults.standard.data(forKey: "searchHistory"),
           let decodedData = try? JSONDecoder().decode([String].self, from: data) {
            return decodedData
        }
        return []
    }
    
    private func updateSearchHistory(with text: String) {
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            return
        }
        
        var updatedHistory = searchHistory
        
        // Check if history already contains this text
        if let index = updatedHistory.firstIndex(of: text) {
            // If you want to move the existing entry to the end:
            updatedHistory.remove(at: index)
        }

        updatedHistory.insert(text, at: 0)
        searchHistory = updatedHistory
        saveSearchHistory(updatedHistory)
    }
    
    var body: some View {
        ZStack {
            if let url = webViewURL {
                WebViewWrapper(url: url, tag: 2, reload: $reloadWebView)
                    .edgesIgnoringSafeArea(.horizontal)
            }
            
            if webViewURL == nil {
                VStack(spacing: 0) {
                    Text("Token Search")
                        .font(.custom("String", size: 25))
                        .fontWeight(.heavy)
                        .padding(.top, 22)
                        .foregroundColor(.black) // Change the text color to red
                    FirstResponderTextField(text: $textFieldText, isFirstResponder: $isFirstResponder, onCommit: { submittedText in
                        let urlString = makeSearchUrl(query: submittedText)

                        if let url = URL(string: urlString) {
                            webViewURL = url
                            isFirstResponder = false
                            updateSearchHistory(with: submittedText)
                            
                        }
                    })
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 100)
                    
                    List {
                        Section(header: Text("Previous Searches")
                            .font(.body)
                            .textCase(nil)) {
                                ForEach(searchHistory, id: \.self) { searchText in
                                    Button(action: {
                                        let urlString = makeSearchUrl(query: searchText)
                                        if let url = URL(string: urlString) {
                                            webViewURL = url
                                            isFirstResponder = false
                                        }
                                    }) {
                                        Text(searchText)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                    }
                    .listStyle(.insetGrouped) // Apply InsetGroupedListStyle to the list
                }
                .background(Color(UIColor(red: 242/255, green: 242/255, blue: 246/255, alpha: 1.0)))
            }
        }
        .transition(.opacity)
        .animation(.default, value: webViewURL)
        .onAppear {
            searchHistory = loadSearchHistory()
        }
    }
}

struct WebViewWrapper: UIViewRepresentable {
    typealias UIViewType = WKWebView

    var url: URL
    var tag: Int
    @Binding var reload: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.tag = tag
        webView.load(URLRequest(url: url))

        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(context.coordinator.handleWebViewReload(notification:)), name: NSNotification.Name("com.user.webView.reload"), object: nil)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if reload {
            uiView.reload()
            reload = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: WebViewWrapper

        init(_ parent: WebViewWrapper) {
            self.parent = parent
        }

        @objc func handleWebViewReload(notification: Notification) {
            parent.reload = true
        }
        
        deinit {
            print("Coordinator is being deallocated")
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct SearchWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct FirstResponderTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    var onCommit: ((String) -> Void)?
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.returnKeyType = .search
        textField.autocorrectionType = .no // Disable autocorrect
        textField.placeholder = "Search Project Name or Ticker"
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor.white
        
        // Custom corner radius and border
        textField.layer.cornerRadius = 10 // Adjust the corner radius as needed
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.clipsToBounds = true
        
        // Create a magnifying glass icon
        let magnifyingGlassIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlassIcon.contentMode = .scaleAspectFit
        magnifyingGlassIcon.tintColor = .gray
        magnifyingGlassIcon.frame = CGRect(x: 14, y: 0, width: 20, height: 20)
        
        // Create a container view for the icon and padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        containerView.addSubview(magnifyingGlassIcon)
        
        textField.leftView = containerView
        textField.leftViewMode = .always // Always show the icon
        
        return textField
    }
    
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFirstResponder {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FirstResponderTextField
        
        init(_ parent: FirstResponderTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            parent.onCommit?(parent.text)
            return true
        }
    }
}
