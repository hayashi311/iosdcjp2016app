//
//  FirstViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/5/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import APIKit

class SessionsViewController: UIViewController, EntityProvider {

    let dataSource = EntityCellMapper()
    var schedule: [SessionGroup] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EntityCellMapper.cellIds.forEach {
            tableView.registerNib(UINib(nibName: $0, bundle: nil),
                forCellReuseIdentifier: $0)
        }

        dataSource.entityProvider = self
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
                s.schedule = response.schedule
                s.tableView.reloadData()
            case let .Failure(e):
                print(e)
            }
        }
    }
    
    func numberOfSections() -> Int {
        return schedule.count
    }
    
    func numberOfEntitiesInSection(section: Int) -> Int {
        return schedule[section].sessions.count
    }
    
    func entityAtIndexPath(index: NSIndexPath) -> AnyEntity? {
        let s = schedule[index.section].sessions[index.row]
        return .Session(session: s)
    }
}

