//  ContentView.swift
//  TKN
//
//  Created by Oak on 4/6/23.
//

import SwiftUI
import SVGKit

struct ContentView: View {
    @State private var selectedTab = 0
    @ObservedObject var model = ViewModel()

    init() {
        model.onTabTappedAgain = { [self] in
            
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab.onUpdate{ model.tabTapped(item: selectedTab) }) {
            WebView(url: URL(string: Constants.tab0)!, tag: 0)
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    TabBarItem(title: "Tokens", image: svgImage(named: "list"))
                }
                .tag(0)
                .background(Color(Constants.backgroundColor))
            WebView(url: URL(string: Constants.tab1)!, tag: 1)
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    TabBarItem(title: "Edit", image: svgImage(named: "edit"))
                }
                .tag(1)
                .background(Color(Constants.backgroundColor))
            SearchViewController()
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    TabBarItem(title: "Search", image: svgImage(named: "search"))
                }
                .tag(2)
                .background(Color(Constants.backgroundColor))
            WebView(url: URL(string: Constants.tab3)!, tag: 3)
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    TabBarItem(title: "Portfolio", image: svgImage(named: "star"))
                }
                .tag(3)
                .background(Color(Constants.backgroundColor))
        }
    }
    
    private func updateWebViewKey() {
        print("Tab tapped again \(selectedTab)")
    }
}

extension Binding {
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure()
        })
    }
}

class ViewModel: ObservableObject {
    @Published private(set) var lastTappedTab: Int?
    
    var onTabTappedAgain: (() -> Void)?

    func tabTapped(item: Int) {
        if lastTappedTab == item {
            print("Tab tapped again with tag: \(item)")
            NotificationCenter.default.post(name: NSNotification.Name("com.user.webView.reload"), object: nil, userInfo: ["selectedTab": item])
            onTabTappedAgain?()
        }
        lastTappedTab = item
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func svgImage(named name: String) -> Image {
    if let url = Bundle.main.url(forResource: name, withExtension: "svg"),
       let data = try? Data(contentsOf: url),
       let image = SVGKImage(data: data),
       let uiImage = image.uiImage {
        return Image(uiImage: uiImage)
    } else {
        return Image(systemName: "exclamationmark.triangle")
    }
}

struct TabBarItem: View {
    let title: String
    let image: Image
    
    var body: some View {
        VStack {
            image
            Text(title)
        }
    }
}

struct SearchViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SearchView {
        return SearchView()
    }
    
    func updateUIViewController(_ uiViewController: SearchView, context: Context) {
        
    }
}
