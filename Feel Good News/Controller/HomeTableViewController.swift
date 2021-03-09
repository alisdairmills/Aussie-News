//
//  ViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var newsManager = NewsManager()
   
    var articleCount: Int?
    var newTitle: String?
    var newAuthor: String?
    var newDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsManager.delegate = self
        newsManager.parseData()
        
        
        
    }
    
    //MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articleCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        
                cell.title.text = newTitle
                cell.author.text = newAuthor
                cell.cellDescription.text = newDescription
    
            return cell
        
}
    }

//MARK: - News Delegate

extension HomeTableViewController: NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: NewsModel) {
       
        articleCount = 0
        newTitle = news.newsTitle
        newAuthor = news.newsAuthor
        newDescription = news.newsDescription
        
        
    }
    
    
}




