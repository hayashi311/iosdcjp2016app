//
//  VoteCodeInputViewController.swift
//  iOSDCJP2016
//
//  Created by Ryota Hayashi on 2016/07/14.
//  Copyright © 2016年 hayashi311. All rights reserved.
//

import UIKit
import APIKit
import URLNavigator
import SVProgressHUD

class VoteCodeInputViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var nid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.attributedText = NSAttributedString(string: "投票コードを入力してください", style: .Body)
        textField.addTarget(self, action: #selector(self.handleInput(_:)), forControlEvents: .EditingChanged)
        doneButton.enabled = enableToSave()
    }

    override func viewDidAppear(animated: Bool) {
        textField.becomeFirstResponder()
    }

    func enableToSave() -> Bool {
        if let voteCode = textField.text where voteCode.characters.count > 3 {
            return true
        }
        return false
    }

    func handleInput(sender: UITextField) {
        doneButton.enabled = enableToSave()
    }

    @IBAction func handleSaveButtonTapped(sender: UIBarButtonItem) {
        guard let voteCode = textField.text else { return }
        NSUserDefaults.standardUserDefaults().vodeCode = voteCode
        textField.resignFirstResponder()
        SVProgressHUD.show()
        let r = WebAPI.VoteRequest(ono: voteCode, nid: nid)
        APIKit.Session.sendRequest(r) {
            [weak self] result in
            switch result {
            case .Success:
                SVProgressHUD.showSuccessWithStatus("Yeah!")
                SVProgressHUD.dismissWithDelay(0.5)
                self?.performSegueWithIdentifier("Exit", sender: self)
            case let .Failure(e):
                SVProgressHUD.showErrorWithStatus("oh...")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
