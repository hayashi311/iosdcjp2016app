//
//  EntityCellMapper.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/8/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit

typealias SpeakerEntity = Speaker
typealias SessionEntity = Session

enum AnyEntity {
    case Speaker(speaker: SpeakerEntity)
    case Session(session: SessionEntity)
    
    var cellId: String {
        get {
            switch self {
            case .Speaker:
                return "SpeakerCell"
            case .Session:
                return "SessionCell"
            }
        }
    }
}

protocol EntityCellMapper: class, UITableViewDataSource {
    func entityAtIndexPath(index: NSIndexPath) -> AnyEntity?
    func numberOfSections() -> Int
    func numberOfEntitiesInSection(section: Int) -> Int
}

extension EntityCellMapper {
    
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfEntitiesInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let entity = entityAtIndexPath(indexPath),
              let cell = tableView.dequeueReusableCellWithIdentifier(entity.cellId) else {
                return UITableViewCell()
        }
        
        switch (cell, entity) {
        case let (c as SpeakerTableViewCell, .Speaker(s)):
            c.nameLabel.text = s.name
            c.twitterAccountLabel.text = s.twitterAccount
        case let (c as SessionTableViewCell, .Session(s)):
            c.titleLabel.text = s.title
        default:
            break
        }
        
        return cell
    }
}
