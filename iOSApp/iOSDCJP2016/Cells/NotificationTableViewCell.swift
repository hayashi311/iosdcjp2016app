//
//  NotificationTableViewCell.swift
//  iOSDCJP2016
//
//  Created by Ryota Hayashi on 2016/07/07.
//  Copyright © 2016年 hayashi311. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()

        textView.textContainer.lineFragmentPadding = 0
        textView.layoutMargins = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
