//
//  NewsViewController.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import UIKit

class NewsViewController: UITableViewController {
    
    var service: NewsService?
    
    private var news: [News] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        service?.load { [weak self] result in
            switch result {
            case let .success(news):
                self?.news = news
            case let .failure(error):
                print(error)
            }
        }
        
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
        cell.titleLabel.text = news.title
        cell.sourceLabel.text = news.source
        cell.bodyLabel.text = news.body
        return cell
    }
    
}
