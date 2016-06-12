//
//  SessionDetailViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/12/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import AlamofireImage

class SessionDetailViewController: UIViewController, DefaultLineHeight {
    var session: Session!

    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var startAtLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var twitterLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomLabel.attributedText = NSAttributedString(string: session.room.rawValue, style: .Body) {
            builder in
            builder.color = UIColor.colorForRoom(self.session.room)
        }
        
        startAtLabel.attributedText = NSAttributedString(string: session.startAt + "-", style: .Body)
        titleLabel.attributedText = NSAttributedString(string: session.title, style: .Title)
        descriptionTextView.attributedText = NSAttributedString(string: session.description, style: .Body)
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.layoutMargins = UIEdgeInsetsZero
        descriptionTextView.layoutManager.delegate = self
        guard let speaker = session.speaker else { return }
        
        
        let buttonTitle = NSAttributedString(string: speaker.twitterAccount, style: .Body) {
            builder in
            builder.color = UIColor.twitterColor()
        }
        twitterLabel.setAttributedTitle(buttonTitle, forState: .Normal)
        
        nameLabel.attributedText = NSAttributedString(string: speaker.name, style: .Body)
        let URL = NSURL(string: APIBaseURL)!.URLByAppendingPathComponent(speaker.image)
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: iconImageView.frame.size,
            radius: iconImageRadius
        )
        
        iconImageView.af_setImageWithURL(
            URL,
            placeholderImage: nil,
            filter: filter,
            imageTransition: .CrossDissolve(0.2)
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
