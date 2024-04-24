//
//  ViewController.swift
//  yourway
//
//  Created by Riley Dou on 4/16/24.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Station {
    let id : String
    let name : String
    let location : [Double]
}

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell", for: indexPath) as! StationTableViewCell

        // Configure the cell (i.e. update UI elements like labels, image views, etc.)
        // Get the row where the cell will be placed using the `row` property on the passed in `indexPath` (i.e., `indexPath.row`)
        let station = myStations[indexPath.row]
        
        cell.name.text = station.name

        // Return the cell for use in the respective table view row
        return cell
    }
    
    private var db = Firestore.firestore()
    private var myStations : [Station] = []
    
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

        // MARK: - Pass the selected movie to the Detail View Controller

        // Get the index path for the selected row.
        // `indexPathForSelectedRow` returns an optional `indexPath`, so we'll unwrap it with a guard.
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }

        // Get the selected movie from the movies array using the selected index path's row
        let selectedStation = myStations[selectedIndexPath.row]

        // Get access to the detail view controller via the segue's destination. (guard to unwrap the optional)
        guard let detailViewController = segue.destination as? DetailViewController else { return }

        detailViewController.stop = selectedStation
    }
    
    private func getDocuments() {

        db.collection("subwayStations").getDocuments()
        {
            (querySnapshot, err) in

            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = data["id"] as? String
                    let name = data["name"] as? String
                    let location = data["location"] as? [Double]
                    
                    let station = Station(id: id!,
                                          name: name!,
                                          location: location!)
                    
                    self.myStations.append(station)
                }
                
                self.tableView.reloadData()
            }
        }
    }


}

