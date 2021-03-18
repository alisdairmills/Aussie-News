//
//  ViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit
import SDWebImage


class HomeViewController: UIViewController {
    
    var newsManager = NewsManager()
    var authorArray = String()
    var titleArray = [String]()
    var urlArray = [String]()
    var imageArray = [String]()
    var dateArray = [String]()
    var articles: [Article]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newsManager.parseData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeTableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        collectionView.delegate = self
        collectionView.dataSource = self
        newsManager.delegate = self
        newsManager.parseData()
    }
    
    func tableViewColour(category: String) -> UIColor {
        
        switch category {
        case "general": return UIColor.green
        case "business": return UIColor.red
        case "entertainment": return UIColor.yellow
        case "health": return UIColor.blue
        case "science": return UIColor.gray
        case "sports": return UIColor.systemPink
        case "technology": return UIColor.purple
        default:
            return UIColor.white
        }
       
    }
}
//MARK: - News Manager Delegate

extension HomeViewController: NewsManagerDelegate {
    
    func updateNews(_ newsManager: NewsManager, news: Articles) {
        DispatchQueue.main.async {
            self.articles = news.data
            self.tableView.reloadData()
            self.authorArray.append(news.data[0].author ?? "")
            print(self.authorArray)
        }
    }
}


//MARK: - TableView Controller

extension HomeViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = articles?.count
        return number ?? 4
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TableViewArticle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewArticle" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! ArticleViewController
                vc.articleURL = articles?[indexPath.row].url
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // must fix this to programattically be height of xib
        return 182
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellArticles = articles?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXib", for: indexPath) as! HomeTableViewCell
        
        cell.mainBackground.layer.cornerRadius = 10
        cell.mainBackground.layer.masksToBounds = true
        cell.mainBackground.layer.borderWidth = 2
        
        //altering background color based on category
        cell.mainBackground.backgroundColor = tableViewColour(category: cellArticles?.category ?? "general")

       
        cell.cellTitle.text = cellArticles?.title
        
        cell.cellCategory.text = cellArticles?.category
        cell.cellSource.text = cellArticles?.source
        
        
        
        
        
        
        //        cell.cellImage.sd_setImage(with: URL(string: imageArray?[indexPath.row] ?? "https://www.setra.com/hubfs/Sajni/crc_error.jpg"))
        //        print(imageArray)
        
        //"https://www.setra.com/hubfs/Sajni/crc_error.jpg"
        return cell
    }
    
    
}

//MARK: - Collection View

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsManager.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        
        
        cell.collectionLabel.text = newsManager.categories[indexPath.row].capitalized
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            //implement some sort of animation
        }
        newsManager.category = newsManager.categories[indexPath.row]
        newsManager.parseData()
        tableView.reloadData()
        
    }
    
    
    
    
}
