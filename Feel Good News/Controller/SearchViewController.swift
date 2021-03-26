//
//  SearchViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var newsManager = NewsManager()
    var dateArray = [String]()
    var searchArray = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeTableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        searchTextField.delegate = self
        
        //implemented this to make the placeholder text darker and more legible against a white background
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        searchTextField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        
        //text field keyboard minimise
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissOnTapOutside() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newsManager.search = "&q=\(searchTextField.text!)"
        DispatchQueue.global(qos: .background).async {
            self.newsManager.parseData(option: "Search")
        }
        tableView.reloadData()
    }
    
    @IBAction func SearchButtonPressed(_ sender: UIButton) {
        
        if searchTextField.text != "" {
            newsManager.search = "&q=\(searchTextField.text ?? "")"
            textFieldDidEndEditing(searchTextField)
        } else {
            searchTextField.placeholder = "Please enter a search topic..."
        }
    }
    
}
//MARK: - NewsManagerDelegate

extension SearchViewController: NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: Articles) {
        
        DispatchQueue.main.async {
            self.searchArray = news.articles
            for i in self.searchArray {
                if i.publishedAt != nil {
                    self.dateArray.append(self.newsManager.dateFormatter(date: i.publishedAt!))
                }
            }
            self.tableView.reloadData()
        }
    }
}


//MARK: - Table View Controller

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 182
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! ArticleViewController
                vc.articleURL = searchArray[indexPath.row].url
                vc.articleTitle = searchArray[indexPath.row].title
                vc.articleName = searchArray[indexPath.row].source?.name
                vc.article = searchArray[indexPath.row]
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SearchSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXib", for: indexPath) as! HomeTableViewCell
        
        let cellArticles = searchArray[indexPath.row]
        
        let color1 = UIColor(displayP3Red: 0.29, green: 0.41, blue: 0.50, alpha: 1.00)
        let color2 = UIColor(displayP3Red: 0.44, green: 0.64, blue: 0.70, alpha: 1.00)
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = color1
        } else { cell.contentView.backgroundColor = color2
        }
        cell.cellImage.layer.cornerRadius = 10
        cell.cellDate.text = dateArray[indexPath.row]
        cell.cellTitle.text = cellArticles.title
        
        //downloads and caches images faster
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





