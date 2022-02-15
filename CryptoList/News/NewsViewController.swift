//
//  NewsViewController.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import UIKit

class NewsViewController: UITableViewController {
    
    var service: NewsService?
    
    var news: [News] = [] {
        didSet{
            guaranteeMainThread {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNews()
    }
    
    func fetchNews(){
        service?.load { [weak self] result in
            switch result {
            case let .success(news):
                self?.news = news
            case let .failure(error):
                guaranteeMainThread {
                    self?.handle(error) {
                        self?.fetchNews()
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsCell
        let news = news[indexPath.row]
        let vm = NewsItemViewModel(news: news)
        cell.configure(vm)
        return cell
    }
    
}
