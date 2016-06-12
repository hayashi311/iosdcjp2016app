//
//  DataSource.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/9/16.
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
                return "SpeakerTableViewCell"
            case .Session:
                return "SessionTableViewCell"
            }
        }
    }
}

protocol EntityProvider: class {
    func entityAtIndexPath(index: NSIndexPath) -> AnyEntity?
    func numberOfSections() -> Int
    func numberOfEntitiesInSection(section: Int) -> Int
}

class EntityCellMapper: NSObject, UITableViewDataSource {
    
    static let cellIds = ["SpeakerTableViewCell", "SessionTableViewCell"]
    
    weak var entityProvider: EntityProvider? = nil
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return entityProvider?.numberOfSections() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entityProvider?.numberOfEntitiesInSection(section) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let entity = entityProvider?.entityAtIndexPath(indexPath),
              let cell = tableView.dequeueReusableCellWithIdentifier(entity.cellId) else {
                return UITableViewCell()
        }
        
        switch (cell, entity) {
        case let (c as SpeakerTableViewCell, .Speaker(s)):
            c.nameLabel.attributedText = NSAttributedString(string: s.name, style: .Body)
            c.twitterAccountLabel.attributedText = NSAttributedString(string: "@" + s.twitterAccount, style: .Small) {
                builder in
                builder.color = UIColor.twitterColor()
            }
        case let (c as SessionTableViewCell, .Session(s)):
            c.titleLabel.attributedText = NSAttributedString(string: s.title, style: .Title)
            c.timeLabel.attributedText = NSAttributedString(string: s.time, style: .Small)
            if let speakerName = s.speaker?.name {
                c.speakerLabel.attributedText = NSAttributedString(string: speakerName, style: .Body)
            }
            c.roomLabel.attributedText = NSAttributedString(string: s.room.rawValue, style: .Small) {
                builder in
                switch s.room {
                case .A:
                    builder.color = UIColor.accentColor()
                case .B:
                    builder.color = UIColor.secondaryAccentColor()
                }
            }
        default:
            break
        }
        
        return cell
    }
}
