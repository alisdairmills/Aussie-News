//
//  ViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit
import SDWebImage
import NaturalLanguage


class HomeViewController: UIViewController {
    
    var newsManager = NewsManager()
    var imageArray = [String]()
    var articles = [Article]()
    var positiveArticles = [Article]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newsManager.parseData()
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "questionmark"), style: .plain, target: self, action: #selector(search))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeTableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        collectionView.delegate = self
        collectionView.dataSource = self
        newsManager.delegate = self
   
    }
    
//    func tableViewColour(category: String) -> UIColor {
//
//        switch category {
//        case "general": return UIColor.green
//        case "business": return UIColor.red
//        case "entertainment": return UIColor.yellow
//        case "health": return UIColor.blue
//        case "science": return UIColor.gray
//        case "sports": return UIColor.systemPink
//        case "technology": return UIColor.purple
//        default:
//            return UIColor.white
//        }
       
    

    @objc func search() {
        //implement search function in here. action a new parse with keyword specifics
        
    }
    func getSentiment(text: String) -> Int {
    let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        
        var sentimentLevel = 0
        
        if score < 0 {
            sentimentLevel = 0
        } else if score > 0 {
            sentimentLevel = 1
        } else {
            sentimentLevel = -1
        }
        
        print(sentimentLevel)
        return sentimentLevel
        
    }
}
//MARK: - News Manager Delegate

extension HomeViewController: NewsManagerDelegate {
    
    func updateNews(_ newsManager: NewsManager, news: Articles) {
        DispatchQueue.main.async {
            self.articles = news.articles
            self.positiveArticles = news.articles
//            self.positiveArticles.removeAll()
//            for i in self.articles {
//                if i.content != nil {
//                    if self.getSentiment(text: i.content!) == 1 {
//                        self.positiveArticles.append(i)
//                    }
//                }
//            }
            self.tableView.reloadData()
        }
    }
}


//MARK: - TableView Controller

extension HomeViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = positiveArticles.count
        return number
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TableViewArticle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewArticle" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! ArticleViewController
                vc.articleURL = positiveArticles[indexPath.row].url
                vc.article = positiveArticles[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // must fix this to programattically be height of xib
        return 182
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellArticles = positiveArticles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXib", for: indexPath) as! HomeTableViewCell
        
        cell.mainBackground.layer.cornerRadius = 10
        cell.mainBackground.layer.masksToBounds = true
        cell.mainBackground.layer.borderWidth = 2
        cell.cellImage.layer.cornerRadius = 10
        
        cell.activitySpinner.startAnimating()
        cell.activitySpinner.hidesWhenStopped = true
        //altering background color based on category
//        cell.mainBackground.backgroundColor = tableViewColour(category: cellArticles.category ?? "general")
        
        cell.cellTitle.text = cellArticles.title
        //cell.cellCategory.text = cellArticles.category
        cell.cellSource.text = cellArticles.source?.name
        
        SDWebImageDownloader.shared.downloadImage(
            with: URL(string: cellArticles.urlToImage ?? ""),
            options: [.highPriority],
            progress: { (receivedSize, expectedSize, url) in
            },
            completed: { [weak self] (image, data, error, finished) in
               if let image = image, finished {
                cell.cellImage.image = image               }
            })
        
        if cell.cellImage != nil {
            cell.activitySpinner.stopAnimating()
        }
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
        cell.collectionView.layer.cornerRadius = 10
        
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
