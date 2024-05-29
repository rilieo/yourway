import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var stationsTableView: UITableView!
    @IBOutlet weak var stopSearchBar: UISearchBar!
    
    var allStations: [Station] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationsTableView.dataSource = self
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allStationsTableViewCell", for: indexPath) as! AllStationsTableViewCell
        
        cell.allStationsLabel.text = allStations[indexPath.row].name
        
        return cell
    }
    
    
}
