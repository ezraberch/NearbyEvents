//
//  MapRouter.swift
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

@objc protocol MapRoutingLogic
{
  func routeToEventDetail(segue: UIStoryboardSegue?)
}

protocol MapDataPassing
{
  var dataStore: MapDataStore? { get }
}

class MapRouter: NSObject, MapRoutingLogic, MapDataPassing
{
  weak var viewController: MapViewController?
  var dataStore: MapDataStore?
  
  // MARK: Routing
  
  func routeToEventDetail(segue: UIStoryboardSegue?)
  {
    if let segue = segue {
      let destinationVC = segue.destination as! EventDetailViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToEventDetail(source: dataStore!, destination: &destinationDS)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let destinationVC = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToEventDetail(source: dataStore!, destination: &destinationDS)
      navigateToEventDetail(source: viewController!, destination: destinationVC)
    }
  }

  // MARK: Navigation
  
  func navigateToEventDetail(source: MapViewController, destination: EventDetailViewController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToEventDetail(source: MapDataStore, destination: inout EventDetailDataStore)
  {
    destination.event = source.event
  }
}
