//
//  ContentView.swift
//  TKN
//
//  Created by Oak on 4/6/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WebView(url: URL(string: "https://tkn.eth.limo")!)
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Label("Tokens", systemImage: "list.bullet.rectangle")
                }
                .tag(0)
            WebView(url: URL(string: "https://tkn.eth.limo/search")!)
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle.fill")
                }
                .tag(1)
            WebView(url: URL(string: "https://tkn.eth.limo?m")!)
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Label("Portfolio", systemImage: "star.square")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
