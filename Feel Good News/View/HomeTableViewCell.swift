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
    @IBOutlet weak var cellTopic: UILabel!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var cellDate: UILabel!
    
    
    override func awakeFromNib() {
       super.awakeFromNib()
        //fix the effect view frame to be perfectly on tectview frame. auto layout issue
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = textView.frame
        effectView.alpha = 1
        
        cellImage.addSubview(effectView)
        
  }

   override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
   }

}

