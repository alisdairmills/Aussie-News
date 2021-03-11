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
        tableView.register(UINib(nibName: "HomeTableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        
        
    }
    
    //MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = articles?.count
        return number ?? 4

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TableViewArticle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewArticle" {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let vc = segue.destination as! ArticleViewController
                    vc.label = articles![indexPath.row].content
                }
            }
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXib", for: indexPath) as! HomeTableViewCell
        let cellArticles = articles?[indexPath.row]
        
        let queue = DispatchQueue.global(qos: .background)
        queue.async() { () -> Void in
            let imageURL = cellArticles?.urlToImage
            
            //change the error url to something else
            let image = self.newsManager.getImage(from: imageURL ?? "https://www.setra.com/hubfs/Sajni/crc_error.jpg")
            
            DispatchQueue.main.async {
                cell.cellImage.image = image
            }
        }
        
        cell.cellTitle.text = cellArticles?.title
        
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

