//
//  HomeTableViewCell.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 9/3/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var cellDate: UILabel!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var cellSource: UILabel!
    
    
    override func awakeFromNib() {
       super.awakeFromNib()

  }

   override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
   }

}

