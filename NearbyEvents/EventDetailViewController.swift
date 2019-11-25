//
//  EventDetailViewController.swift
//  NearbyEvents
//
//  Created by Ezra Berch on 1/1/19.
//  Copyright (c) 2019 Ezra Berch. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EventDetailDisplayLogic: class
{
    func displaySomething(viewModel: EventDetail.Something.ViewModel)
}

class EventDetailViewController: UIViewController, EventDetailDisplayLogic
{
    var interactor: EventDetailBusinessLogic?
    var router: (NSObjectProtocol & EventDetailRoutingLogic & EventDetailDataPassing)?
    
    
    @IBOutlet weak var eventTitle: UINavigationItem!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var starttime: UILabel!
    @IBOutlet weak var endtime: UILabel!
    @IBOutlet weak var urlView: UITextView!
    @IBOutlet weak var favorite: UIButton!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = EventDetailInteractor()
        let presenter = EventDetailPresenter()
        let router = EventDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let event = interactor!.event {
            eventTitle.title = event.title
            if let description = event.description {
                do {
                    let attString = try NSAttributedString(data: description.data(using: String.Encoding.utf8)!, options: [.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil)
                    detailText.attributedText = attString
                } catch {
                    detailText.text = description
                }
            } else {
                detailText.text = "No description"
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
            let formatterPrint = DateFormatter()
            formatterPrint.dateFormat = "MMM dd, yyyy h:mm a"
            if let date=formatter.date(from: event.start_time) {
                starttime.text = formatterPrint.string(from: date)
            } else {
                starttime.text = event.start_time
            }
            if let stop_time = event.stop_time {
                if let date=formatter.date(from: stop_time) {
                    endtime.text = formatterPrint.string(from: date)
                }    else {
                    endtime.text = stop_time
                }
            } else {
                endtime.text = ""
            }
            urlView.text = event.url.absoluteString
            
            updateButton()
        }
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doSomething()
    {
        let request = EventDetail.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        CoreDataStore.shared.toggleEvent(event: interactor!.event!) { result in
            self.updateButton()
        }
    }
    
    func updateButton() {
        CoreDataStore.shared.checkID(id: self.interactor!.event!.id) { result in
            if result != nil {
                self.favorite.setTitle("Remove from Favorites", for: UIControl.State.normal)
            }
            else {
                self.favorite.setTitle("Add to Favorites", for: UIControl.State.normal)
            }
        }
    }
    
    func displaySomething(viewModel: EventDetail.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
}
