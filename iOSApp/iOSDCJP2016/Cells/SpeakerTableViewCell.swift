//
//  SpeakerTableViewCell.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/7/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit

class SpeakerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterAccountLabel: UILabel!
    
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
