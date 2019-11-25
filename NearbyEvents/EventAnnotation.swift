//
//  EventAnnotation.swift
//  NearbyEvents
//
//  Created by Ezra Berch on 1/1/19.
//  Copyright © 2019 Ezra Berch. All rights reserved.
//

import UIKit
import MapKit

class EventAnnotation: MKPointAnnotation {
    let id: String
    init(id: String) {
        self.id = id
        super.init()
    }
}
