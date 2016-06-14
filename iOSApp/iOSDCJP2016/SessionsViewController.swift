//
//  FirstViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/5/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import APIKit

class SessionsViewController: UIViewController, EntityProvider, UITableViewDelegate {

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
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "SessionSectionHeaderView", bundle: nil),
                              forHeaderFooterViewReuseIdentifier: "SectionHeader")
        
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
    
    override func viewWillAppear(animated: Bool) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SectionHeader")
                                                                as? SessionSectionHeaderView else {
            return nil
        }
        let startAt = schedule[section].startAt
        h.label.attributedText = NSAttributedString(string: startAt, style: .Body) {
            builder in
            builder.weight = .Bold
        }
        return h
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard case let .Some(.Session(session: session)) = entityAtIndexPath(indexPath) else {
            return
        }
        guard let controller = storyboard?.instantiateViewControllerWithIdentifier("SessionDetailViewController")
                                                                            as? SessionDetailViewController else {
            return
        }

        controller.session = session
        navigationController?.pushViewController(controller, animated: true)
    }
}

