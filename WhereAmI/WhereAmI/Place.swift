//
//  Place.swift
//  WhereAmI
//
//  Created by Lei Zhao on 7/4/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import MapKit

class Place: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
