//
//  ViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var newsManager = NewsManager()
    var imageArray = [String]()
    var articles = [Article]()
    var dateArray = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async {
            self.newsManager.parseData(option: "General")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        collectionView.delegate = self
        collectionView.dataSource = self
        newsManager.delegate = self
    }
    
}

//MARK: - NewsManager Delegate

extension HomeViewController: NewsManagerDelegate {
    
    func updateNews(_ newsManager: NewsManager, news: Articles) {
        DispatchQueue.main.async {
            self.articles = news.articles
            self.articles = news.articles
            for i in self.articles {
                if i.publishedAt != nil {
                    self.dateArray.append(self.newsManager.dateFormatter(date: i.publishedAt!))
                }
            }
            
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableViewController

extension HomeViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 182
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewArticle" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! ArticleViewController
                vc.articleURL = articles[indexPath.row].url
                vc.articleTitle = articles[indexPath.row].title
                vc.articleName = articles[indexPath.row].source?.name
                vc.article = articles[indexPath.row]
                vc.date = dateArray[indexPath.row]
        
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalArray.dateArrayGlobal.insert(dateArray[indexPath.row], at: 0)
        performSegue(withIdentifier: "TableViewArticle", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellArticles = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXib", for: indexPath) as! HomeTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else { cell.contentView.backgroundColor = UIColor.lightGray
        }
        cell.cellImage.layer.cornerRadius = 10
        cell.cellDate.text = dateArray[indexPath.row]
        cell.cellTitle.text = cellArticles.title
        
        //downloads and caches images faster
        SDWebImageDownloader.shared.downloadImage(
            with: URL(string: cellArticles.urlToImage ?? ""),
            options: [.highPriority, .continueInBackground, .avoidDecodeImage, .decodeFirstFrameOnly],
            progress: { (receivedSize, expectedSize, url) in
            },
            completed: { [weak self] (image, data, error, finished) in
                if let image = image, finished {
                    cell.cellImage.image = image               }
            })
        
        return cell
    }
    
}

//MARK: - CollectionViewController

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsManager.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        cell.lines.isHidden = true
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.white
        } else { cell.backgroundColor = UIColor.lightGray
        }
        cell.collectionLabel.text = newsManager.categories[indexPath.row].capitalized
        cell.collectionView.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.lines.isHidden = false
            
            newsManager.category = newsManager.categories[indexPath.row]
            DispatchQueue.global(qos: .background).async {
                self.newsManager.parseData(option: "General")
            }
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.lines.isHidden = true
        }
    }
}
