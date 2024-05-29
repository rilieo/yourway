//
//  ViewController.swift
//  yourway
//
//  Created by Riley Dou on 4/16/24.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    private var db = Firestore.firestore()
    private var myStations: [Station] = []
    private var allStations: [Station] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        getDocuments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // get the index path for the selected row
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            // Deselect the currently selected row
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            let selectedStation = myStations[selectedIndexPath.row]
            detailViewController.stop = selectedStation
        }

        if let searchViewController = segue.destination as? SearchViewController {
            searchViewController.allStations = allStations
        }

    }
    
    private func getDocuments() {

        db.collection("subwayStations").getDocuments() {
            (querySnapshot, err) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.myStations = documents.map { (queryDocumentSnapshot) -> Station in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let location = data["location"] as? [Double] ?? [0.0, 0.0]
//                let stops = data["stops"] as? [String: [Double]] ?? ["": [0.0, 0.0]]
                return Station(id: id, location: location, name: name)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        db.collection("allStations").order(by: "name").getDocuments() {
            (querySnapshot, err) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.allStations = documents.map { (queryDocumentSnapshot) -> Station in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let location = data["location"] as? [Double] ?? [0.0, 0.0]
                // let stops = data["stops"] as? [String: [Double]] ?? ["": [0.0, 0.0]]
                return Station(id: id, location: location, name: name)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationTableViewCell", for: indexPath) as! StationTableViewCell

        // Configure the cell (i.e. update UI elements like labels, image views, etc.)
        // Get the row where the cell will be placed using the `row` property on the passed in `indexPath` (i.e., `indexPath.row`)
        cell.stationLabel.text = myStations[indexPath.row].name

        // Return the cell for use in the respective table view row
        return cell
    }
}

