//
//  SessionDetailViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/12/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit

class SessionDetailViewController: UIViewController {
    var session: Session!

    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var startAtLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomLabel.attributedText = NSAttributedString(string: session.room.rawValue, style: .Body) {
            builder in
            builder.color = UIColor.colorForRoom(self.session.room)
        }
        
        startAtLabel.attributedText = NSAttributedString(string: session.startAt + "-", style: .Body)
        titleLabel.attributedText = NSAttributedString(string: session.title, style: .Title)
        descriptionTextView.attributedText = NSAttributedString(string: session.description, style: .Body)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
