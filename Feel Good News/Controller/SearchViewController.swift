//
//  SearchViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit
import SDWebImage

//implement a link to webview when article pressed
//implement search functionality to change URL
//build view if array is empty
// implement text field delegate
//search popup view of recent searches?


class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var newsManager = NewsManager()
    
    var searchArray = [Article]()
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeTableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        newsManager.delegate = self
        tableView.isHidden = true
        searchTextField.placeholder = "Search..."
        searchTextField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        newsManager.search = searchTextField.text ?? "general"
        newsManager.parseData()
        tableView.reloadData()
        if searchArray.isEmpty {
            tableView.isHidden = true
            //add a view here that nothing could be found
        } else {
        tableView.isHidden = false
        }
    }
    


}

//MARK: - NewsManager Delegate

extension SearchViewController: NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: Articles) {
        self.searchArray = news.articles
    }
    
    
}


//MARK: - Table View Controller

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXib", for: indexPath) as! HomeTableViewCell
        
        let cellArticles = searchArray[indexPath.row]
        
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
        //cell.cellDate.text = dateArray[indexPath.row]
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182
    }
    


