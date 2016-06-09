//
//  FirstViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/5/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import APIKit

class SessionsViewController: UIViewController {

    let dataSource = DataSource()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataSource.cellIds.forEach {
            tableView.registerNib(UINib(nibName: $0, bundle: nil),
                forCellReuseIdentifier: $0)
        }

        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        let r = WebAPI.SessionsRequest()
        APIKit.Session.sendRequest(r) {
            [weak self] result in
            guard let s = self else { return }
            switch result {
            case let .Success(response):
                s.dataSource.entities = response.sessions.map {
                    AnyEntity.Session(session: $0)
                }
                s.tableView.reloadData()
                print(response)
            case let .Failure(e):
                print(e)
            }
        }
    }
}

