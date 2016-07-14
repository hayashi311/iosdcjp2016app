//
//  SponsorsViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 7/10/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import APIKit
import SafariServices

class SponsorsViewController: UITableViewController, EntityProvider {

    let dataSource = EntityCellMapper()
    var tiers: [SponsorTier] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "スポンサー"
        
        EntityCellMapper.cellIds.forEach {
            tableView.registerNib(UINib(nibName: $0, bundle: nil),
                forCellReuseIdentifier: $0)
        }
        
        dataSource.entityProvider = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "SessionSectionHeaderView", bundle: nil),
                              forHeaderFooterViewReuseIdentifier: "SectionHeader")

        let r = WebAPI.SponsorsRequest()
        APIKit.Session.sendRequest(r) {
            [weak self] result in
            guard let s = self else { return }
            switch result {
            case let .Success(response):
                s.tiers = response.tiers
                s.tableView.reloadData()
            case let .Failure(e):
                print(e)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections() -> Int {
        return tiers.count
    }
    
    func numberOfEntitiesInSection(section: Int) -> Int {
        guard tiers.indices.contains(section) else {
                return 0
        }
        return tiers[section].sponsors.count
    }
    
    func entityAtIndexPath(index: NSIndexPath) -> AnyEntity? {
        guard tiers.indices.contains(index.section) &&
            tiers[index.section].sponsors.indices.contains(index.row) else {
                return nil
        }
        return .Sponsor(sponsor: tiers[index.section].sponsors[index.row])
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SectionHeader")
            as? SessionSectionHeaderView else {
                return nil
        }
        let name = tiers[section].name
        h.label.attributedText = NSAttributedString(string: name, style: .Body) {
            builder in
            builder.weight = .Bold
        }
        return h
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let url = entityAtIndexPath(indexPath)?.url else { return }
        let vc = SFSafariViewController(URL: url)
        presentViewController(vc, animated: true, completion: nil)
    }
}
