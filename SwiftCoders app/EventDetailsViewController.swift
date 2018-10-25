//
//  GroupsViewController.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 9/12/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit
import MapKit

final class EventDetailsViewController: UIViewController {
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var dateNameLabel: UILabel!
    @IBOutlet var mapView: MKMapView! {
        didSet {
            mapView.isScrollEnabled = false
            mapView.isRotateEnabled = false
            mapView.isZoomEnabled = false
            mapView.isPitchEnabled = false
        }
    }

    var object: EventData!

    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(object != nil)

        title = object.event.name
        groupNameLabel.text = object.group.name
        dateNameLabel.text = object.event.localDate
        mapView.addAnnotation(object.event.venue)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.showAnnotations([object.event.venue], animated: false)
    }
}

extension EventDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
    }
}
