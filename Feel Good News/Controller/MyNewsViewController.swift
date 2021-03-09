//
//  MyNewsViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit

class MyNewsViewController: UIViewController {

    var newsManager = NewsManager()
    var articles = [Article]()

    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsManager.delegate = self
        newsManager.parseData()
        }
   
    }
    
extension MyNewsViewController: NewsManagerDelegate{


func updateNews(_ newsManager: NewsManager, news: NewsModel) {
   
}

}

