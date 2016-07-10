//
//  SponsorTableViewCell.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 7/10/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit

class SponsorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sponsorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
