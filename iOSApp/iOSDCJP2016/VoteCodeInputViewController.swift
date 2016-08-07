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

class VoteCodeInputViewController: UIViewController, URLNavigable {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let nid: String
    
    init(nid: String) {
        self.nid = nid
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience required init?(URL: URLConvertible, values: [String : AnyObject]) {
        guard let nid = values["nid"] as? String else {
            return nil
        }
        self.init(nid: nid)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


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
        let r = WebAPI.VoteRequest(ono: voteCode, nid: nid)
        APIKit.Session.sendRequest(r) {
            [weak self] result in
            switch result {
            case let .Success(response):
                print(response)
                self?.performSegueWithIdentifier("Exit", sender: self)
            case let .Failure(e):
                print(e)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
