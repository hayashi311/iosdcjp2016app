//
//  Sponsor.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 7/10/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import Foundation
import Unbox


struct Sponsor: Unboxable {
    let name: String
    let description: String?
    let image: String?
    let url: String?
    
    init(unboxer: Unboxer) {
        name = unboxer.unbox("name")
        description = unboxer.unbox("description")
        image = unboxer.unbox("image")
        url = unboxer.unbox("url")
    }
}

struct SponsorTier: Unboxable {
    let name: String
    let sponsors: [Sponsor]
    
    init(unboxer: Unboxer) {
        name = unboxer.unbox("name")
        sponsors = unboxer.unbox("sponsors")
    }
}
