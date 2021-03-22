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
    var dateArray = [String]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newsManager.parseData()
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(search))
        
        dateFormatter(date: "2021-03-21T17:30:00Z")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeTableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        collectionView.delegate = self
        collectionView.dataSource = self
        newsManager.delegate = self
   
    }
    

       
    

    @objc func search() {
        
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
    func dateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date!)
    }
    
    
}
//MARK: - News Manager Delegate

extension HomeViewController: NewsManagerDelegate {
    
    func updateNews(_ newsManager: NewsManager, news: Articles) {
        DispatchQueue.main.async {
            self.articles = news.articles
            self.positiveArticles = news.articles
            for i in self.articles {
                if i.publishedAt != nil {
                    self.dateArray.append(self.dateFormatter(date: i.publishedAt!))
                }
            }
            
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
                vc.articleTitle = positiveArticles[indexPath.row].title
                vc.articleName = positiveArticles[indexPath.row].source?.name
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
       
        let color1 = UIColor(displayP3Red: 0.29, green: 0.41, blue: 0.50, alpha: 1.00)
        let color2 = UIColor(displayP3Red: 0.44, green: 0.64, blue: 0.70, alpha: 1.00)
        
        if indexPath.row % 2 == 0 {
            cell.mainBackground.backgroundColor = color1
        } else { cell.mainBackground.backgroundColor = color2
        }
        
        
        
        cell.mainBackground.layer.cornerRadius = 10
        cell.mainBackground.layer.masksToBounds = true
        cell.mainBackground.layer.borderWidth = 1
        cell.cellImage.layer.cornerRadius = 10
        cell.cellTitle.text = cellArticles.title
        cell.cellDate.text = dateArray[indexPath.row]
        cell.cellSource.text = cellArticles.source?.name
        
        SDWebImageDownloader.shared.downloadImage(
            with: URL(string: cellArticles.urlToImage ?? ""),
            options: [.highPriority, .continueInBackground],
            progress: { (receivedSize, expectedSize, url) in
            },
            completed: { [weak self] (image, data, error, finished) in
               if let image = image, finished {
                cell.cellImage.image = image               }
            })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        <#code#>
    }
}

//MARK: - Collection View

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsManager.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        
        let color1 = UIColor(displayP3Red: 0.29, green: 0.41, blue: 0.50, alpha: 1.00)
        let color2 = UIColor(displayP3Red: 0.44, green: 0.64, blue: 0.70, alpha: 1.00)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = color1
        } else { cell.backgroundColor = color2
        }
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
