//
//  SecondViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/5/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import APIKit

class SpeakersViewController: UIViewController, EntityProvider {

    let dataSource = EntityCellMapper()
    var speakers: [Speaker] = []

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
        
        let r = WebAPI.SpeakersRequest()
        APIKit.Session.sendRequest(r) {
            [weak self] result in
            guard let s = self else { return }
            switch result {
            case let .Success(response):
                s.speakers = response.speakers
                s.tableView.reloadData()
                print(response)
            case let .Failure(e):
                print(e)
            }
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfEntitiesInSection(section: Int) -> Int {
        return speakers.count
    }
    
    func entityAtIndexPath(index: NSIndexPath) -> AnyEntity? {
        guard speakers.indices.contains(index.row) else { return nil }
        return .Speaker(speaker: speakers[index.row])
    }
}

