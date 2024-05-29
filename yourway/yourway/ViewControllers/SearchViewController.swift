import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var stationsTableView: UITableView!
    @IBOutlet weak var stopSearchBar: UISearchBar!
    
    var allStations: [Station] = []
    var searchStations: [Station] = []
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationsTableView.dataSource = self
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching) {
            return searchStations.count
        }
        
        return allStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allStationsTableViewCell", for: indexPath) as! AllStationsTableViewCell
        
        if (searching) {
            cell.allStationsLabel.text = searchStations[indexPath.row].name
        } else {
            cell.allStationsLabel.text = allStations[indexPath.row].name
        }
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStations = allStations.filter({$0.name.prefix(searchText.count) == searchText})
        searching = true
        stationsTableView.reloadData()
    }
}
