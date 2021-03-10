//
//  ViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var newsManager = NewsManager()
    var articles: [Article]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsManager.delegate = self
        newsManager.parseData()
        
    }
    
    //MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = articles?.count
        return number ?? 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        
        let cellArticles = articles?[indexPath.row]
    
        cell.title.text = cellArticles?.title
        cell.author.text = cellArticles?.author
        
        return cell
}
    }

//MARK: - News Manager Delegate

extension HomeTableViewController: NewsManagerDelegate {
    
    func updateNews(_ newsManager: NewsManager, news: Articles) {
        DispatchQueue.main.async {
            self.articles = news.articles
            self.tableView.reloadData()
           
        }
    }
}

