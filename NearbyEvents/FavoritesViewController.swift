//
//  SecondViewController.swift
//  NearbyEvents
//
//  Created by Ezra Berch on 12/31/18.
//  Copyright © 2018 Ezra Berch. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    var event: Event?
    var events: [SavedEvent] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events=[]
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CoreDataStore.shared.fetchEvents { (events, error) in
            self.events = events
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        cell.textLabel?.text = events[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataStore.shared.deleteEvent(event: self.events[indexPath.row]) { (events, error) in
                if error == nil {
                    self.events = events
                }
                tableView.reloadData()
                }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savedEvent: SavedEvent = events[indexPath.row]
        event = Event(id: savedEvent.id!, url: savedEvent.url!, title:savedEvent.title!, description: savedEvent.eventDescription, latitude: savedEvent.latittude!, longitude: savedEvent.longitude!, start_time: savedEvent.start_time!, stop_time: savedEvent.stop_time)
        performSegue(withIdentifier: "FavoriteDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteDetail" {
            if let destination = segue.destination as? EventDetailViewController {
                destination.interactor?.event = event
            }
        }
    }

}

