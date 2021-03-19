//
//  SavedViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 19/3/21.
//

import UIKit
import SDWebImage



class SavedViewController: UIViewController {
   

    @IBOutlet weak var tableView: UITableView!
    
    var articleViewController = ArticleViewController()
    var articles: [Article]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if articles != nil {
        self.tableView.reloadData()
           
        }
        print(articles?.count)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "HomeTableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
        
    }
}


//MARK: - table view
extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXib", for: indexPath) as! HomeTableViewCell
        
        let cellArticles = articles?[indexPath.row]
        cell.mainBackground.layer.cornerRadius = 10
        cell.mainBackground.layer.masksToBounds = true
        cell.mainBackground.layer.borderWidth = 2
        cell.cellImage.layer.cornerRadius = 10
        
        cell.activitySpinner.startAnimating()
        cell.activitySpinner.hidesWhenStopped = true

        cell.cellTitle.text = cellArticles?.title
     
        cell.cellSource.text = cellArticles?.source?.name
        
        SDWebImageDownloader.shared.downloadImage(
            with: URL(string: cellArticles?.urlToImage ?? ""),
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
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SavedSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! ArticleViewController
                vc.articleURL = articles?[indexPath.row].url
            }
        }
    }
    
    
}
