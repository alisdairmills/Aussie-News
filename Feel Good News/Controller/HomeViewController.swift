//
//  ViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit

class HomeTableViewController: UITableViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NewsManager.shared.getNews { (news) in
            guard let news = news else {return}
            print(news[0].title)
        }
    }


}

