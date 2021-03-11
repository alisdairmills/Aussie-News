//
//  ArticleViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit

class ArticleViewController: UIViewController {

    var label: String?
    
    @IBOutlet weak var articleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        articleLabel.text = label
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
