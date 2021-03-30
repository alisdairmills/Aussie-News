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
        articles = GlobalArray.savedArrayGlobal
           tableView.reloadData()
        if articles.isEmpty {
            let ac = UIAlertController(title: "", message: "Saved articles will be stored here", preferredStyle: .alert)
            self.present(ac, animated: true) {
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissAC))
                ac.view.superview?.subviews[0].addGestureRecognizer(tap)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewXib", bundle: nil), forCellReuseIdentifier: "CellXib")
      
    }
    @objc func dismissAC() {
        self.dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            GlobalArray.dateArrayGlobal.remove(at: indexPath.row)
            GlobalArray.savedArrayGlobal.remove(at: indexPath.row)
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
          
        }
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
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else { cell.contentView.backgroundColor = UIColor.lightGray
        }
        cell.cellImage.layer.cornerRadius = 10
        cell.cellTitle.text = cellArticles.title
        cell.cellDate.text = GlobalArray.dateArrayGlobal[indexPath.row]
        
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
   

 

