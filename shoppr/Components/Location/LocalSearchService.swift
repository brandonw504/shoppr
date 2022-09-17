//
//  LocalSearchService.swift
//  shoppr
//
//  Created by Brandon Wong on 7/20/22.
//

import Foundation
import Combine
import MapKit

final class LocalSearchService {
    let localSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    private let radius: CLLocationDistance

    init(radius: CLLocationDistance = 5000) {
        self.radius = radius
    }
    
    public func search(searchText: String, center: CLLocationCoordinate2D) {
        request(searchText: searchText, center: center)
    }
    
    private func request(searchText: String, center: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius)
        let search = MKLocalSearch(request: request)

        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }

            self?.localSearchPublisher.send(response.mapItems)
        }
    }
}
