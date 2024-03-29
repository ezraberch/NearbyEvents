//
//  MapPresenter.swift
//  NearbyEvents
//
//  Created by Ezra Berch on 12/31/18.
//  Copyright (c) 2018 Ezra Berch. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MapKit

protocol MapPresentationLogic
{
    func presentMapConfig(response: Map.ConfigureMap.Response)
    func presentEvents(response: Map.GetEvents.Response)
}

class MapPresenter: MapPresentationLogic
{
    weak var viewController: MapDisplayLogic?
    
    // MARK: Do something
    
    func presentMapConfig(response: Map.ConfigureMap.Response)
    {
        let coord = CLLocationCoordinate2D(latitude: response.latitude, longitude: response.longitude)
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: 100000, longitudinalMeters: 100000)
        let viewModel = Map.ConfigureMap.ViewModel(region: region)
        viewController?.centerMap(viewModel: viewModel)
    }
    
    func presentEvents(response: Map.GetEvents.Response)
    {
        let viewModel = Map.GetEvents.ViewModel(events: response.events, error: response.error)
        viewController?.displayEvents(viewModel: viewModel)
    }
}
