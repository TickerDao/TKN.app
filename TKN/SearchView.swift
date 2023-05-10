//
//  SearchView.swift
//  TKN
//
//  Created by Oak on 5/10/23.
//  Copyright © 2023 Superadditive. All rights reserved.
//

import Foundation
import UIKit

class SearchView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let searchTextField = UITextField()
    let tableView = UITableView()
    var searchHistory: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let webView = UIWebView(url: URL(string: Constants.tab2)!, tag: 2) // Default URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleWebViewReload(notification:)), name: NSNotification.Name("com.user.webView.reload"), object: nil)
        
        loadSearchHistory()
        self.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 246/255, alpha: 1.0)
        setupUI()
        setupWebView()
        
        searchTextField.autocorrectionType = .no
    }
    
    func setupWebView() {
        // Add webView to your view hierarchy and set its constraints
        view.addSubview(webView)
        // Add constraints for webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        webView.isHidden = true // Initially, hide the webView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (webView.isHidden) {
            searchTextField.becomeFirstResponder()
        }
    }
    
    @objc func handleWebViewReload(notification: NSNotification) {
        if let userInfo = notification.userInfo, let selectedTab = userInfo["selectedTab"] as? Int {
            if selectedTab == 2 {
                webView.isHidden = true // Show the webView
                tableView.isHidden = false // Hide the tableView
                searchTextField.becomeFirstResponder()
                searchTextField.text = ""
            }
        }
    }
    
    func saveSearchHistory() {
        let defaults = UserDefaults.standard
        defaults.set(searchHistory, forKey: "SearchHistory")
    }

    func loadSearchHistory() {
        let defaults = UserDefaults.standard
        searchHistory = defaults.object(forKey: "SearchHistory") as? [String] ?? [String]()
    }

    
    func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Token Search"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        titleLabel.textColor = .gray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        
        // Search TextField
        searchTextField.delegate = self
        searchTextField.placeholder = "Project Name or Ticker"
        searchTextField.autocorrectionType = .no
        searchTextField.returnKeyType = .search
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 12
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.layer.shadowColor = UIColor.black.cgColor
        searchTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchTextField.layer.shadowOpacity = 0.1
        searchTextField.layer.shadowRadius = 4.0
        searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        let searchIcon = UIImage(systemName: "magnifyingglass")
        let searchIconView = UIImageView(image: searchIcon)
        searchIconView.tintColor = .gray
        searchIconView.frame = CGRect(x: 15, y: 0, width: searchIconView.image!.size.width, height: searchIconView.image!.size.height)
        searchIconView.contentMode = .center

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: searchIconView.frame.width + 30, height: searchIconView.frame.height)) // 15 padding on each side
        paddingView.addSubview(searchIconView)
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchTextField.frame.height))
        searchTextField.rightView = rightPaddingView
        searchTextField.rightViewMode = .always

        searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchTextField)
        
        let recentLabel = UILabel()
        recentLabel.text = "Previous Searches"
        recentLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        recentLabel.textColor = .gray
        recentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(recentLabel)
        
        // TableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        // Top border
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.00)
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topBorderView)
        NSLayoutConstraint.activate([
            topBorderView.topAnchor.constraint(equalTo: tableView.topAnchor),
            topBorderView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // Bottom border
        let bottomBorderView = UIView()
        bottomBorderView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.00)
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBorderView)
        NSLayoutConstraint.activate([
            bottomBorderView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            bottomBorderView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            bottomBorderView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            recentLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 22),
            recentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        textField.resignFirstResponder()
        
        // Remove text from searchHistory if it exists
        if let index = searchHistory.firstIndex(of: text) {
            searchHistory.remove(at: index)
        }
        
        // Add new search query to the start of searchHistory array
        searchHistory.insert(text, at: 0)
        
        saveSearchHistory() // Save search history after each search
        searchTextField.resignFirstResponder()
        
        // Post notification with search query
        NotificationCenter.default.post(name: NSNotification.Name("SearchQueryChange"), object: nil, userInfo: ["query": text])

        // Load the search result in webView
        let searchURL = URL(string: makeSearchUrl(query: text))
        let request = URLRequest(url: searchURL!)
        webView.webView!.load(request)
        webView.isHidden = false // Show the webView
        tableView.isHidden = true // Hide the tableView
        
        // Handle search action here
        return true
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchHistory.count == 0) {
            return 1
        }
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (searchHistory.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "No Search History"
            cell.textLabel?.textColor = .lightGray
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchHistory[indexPath.row]
        cell.textLabel?.textColor = .lightGray
        return cell
    }

    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (searchHistory.count == 0) {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let searchText = searchHistory[indexPath.row]
        searchTextField.text = searchText
        searchTextField.resignFirstResponder()
        
        // Load the search result in webView
        let searchURL = URL(string: makeSearchUrl(query: searchText))
        let request = URLRequest(url: searchURL!)
        webView.webView!.load(request)
        webView.isHidden = false // Show the webView
        tableView.isHidden = true // Hide the tableView
    }
}


