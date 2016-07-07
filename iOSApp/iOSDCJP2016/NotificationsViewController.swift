//
//  NotificationsViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 7/2/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import APIKit

class NotificationsViewController: UIViewController, EntityProvider {

    let dataSource = EntityCellMapper()
    var notifications: [Notification] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "お知らせ"

        EntityCellMapper.cellIds.forEach {
            tableView.registerNib(UINib(nibName: $0, bundle: nil),
                forCellReuseIdentifier: $0)
        }

        dataSource.entityProvider = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        let r = WebAPI.NotificationsRequest()
        APIKit.Session.sendRequest(r) {
            [weak self] result in
            guard let s = self else { return }
            switch result {
            case let .Success(response):
                s.notifications = response.notifications
                s.tableView.reloadData()
                print(response.notifications)
            case let .Failure(e):
                print(e)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfEntitiesInSection(section: Int) -> Int {
        return notifications.count
    }
    
    func entityAtIndexPath(index: NSIndexPath) -> AnyEntity? {
        guard notifications.indices.contains(index.row) else { return nil }
        return .Notification(notification: notifications[index.row])
    }
}
