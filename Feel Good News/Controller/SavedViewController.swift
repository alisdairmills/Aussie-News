//
//  SavedViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 26/3/21.
//

import UIKit
import SDWebImage


class SavedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
   
    var articles = [Article]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        articles = GlobalArray.SavedArrayGlobal
           tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeTableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        
        }
    

    }
    

    //MARK: - TableViewDelegate
    
extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 182
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SavedSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! ArticleViewController
                vc.articleURL = articles[indexPath.row].url
                vc.articleTitle = articles[indexPath.row].title
                vc.articleName = articles[indexPath.row].source?.name
                vc.article = articles[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SavedSegue", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXib", for: indexPath) as! HomeTableViewCell
        
        let cellArticles = articles[indexPath.row]
        
        let color1 = UIColor(displayP3Red: 0.29, green: 0.41, blue: 0.50, alpha: 1.00)
        let color2 = UIColor(displayP3Red: 0.44, green: 0.64, blue: 0.70, alpha: 1.00)
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = color1
        } else { cell.contentView.backgroundColor = color2
        }
        cell.cellImage.layer.cornerRadius = 10
        
        //fix the date on this. carry info over from artivle view controller
        //cell.cellDate.text = cellArticles.publishedAt
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
   

 

