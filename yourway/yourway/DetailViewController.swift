//
//  DetailViewController.swift
//  yourway
//
//  Created by Riley Dou on 4/23/24.
//

import UIKit

struct TrainInfo {
    let time : String
    let line : String
}

class DetailViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == uptownTrainsTableView) {
            return NStations.count
        }
        
        return SStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == uptownTrainsTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "uptownTableViewCell", for: indexPath) as! UptownTableViewCell
            
            cell.trainLine.text = NStations[indexPath.row].line
            cell.trainTime.text = NStations[indexPath.row].time
            return cell
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "downtownTableViewCell", for: indexPath) as! DowntownTableViewCell
        
        cell.trainLine.text = SStations[indexPath.row].line
        cell.trainTime.text = SStations[indexPath.row].time
        
        return cell
        
    }
    
    @IBOutlet weak var uptownTrainsTableView: UITableView!
    @IBOutlet weak var downtownTrainsTableView: UITableView!
    var stop: Station!
    
    private var NStations : [TrainInfo] = []
    private var SStations : [TrainInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStops()
        uptownTrainsTableView.dataSource = self
        downtownTrainsTableView.dataSource = self
    }
    
    private func fetchStops() {
        let lat = stop.location[0]
        let lon = stop.location[1]
        let url = URL(string: "http://127.0.0.1:5000/by-location?lat=\(lat)&lon=\(lon)")!
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let subwayStops = try JSONDecoder().decode(Stop.self, from: data)
                let stationData = subwayStops.data
                var north : [TrainInfo] = []
                var south : [TrainInfo] = []
                
                // Iterate through all stations from stationData and display these stations
                for station in stationData {
                    if (station.name == self.stop.name) {
                        // Get next "northbound" train
                        let nStations = station.N
                        
                        for nStation in nStations {
                            let timestamp = nStation.time.parseTime()
                            
                            // Parse time
                            var route = nStation.route
                            if route.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567")) != nil {
                                route = nStation.route.replacingOccurrences(of: #"[^\d\s]"#, with: "", options:     .regularExpression)
                            }
                            
                            north.append(TrainInfo(time: timestamp, line: route))
                        }
                        
                        // Get next "southbound" train
                        let sStations = station.S
                        
                        for sStation in sStations {
                            let timestamp = sStation.time.parseTime()
                            
                            // Parse time
                            var route = sStation.route
                            if route.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567")) != nil {
                                route = sStation.route.replacingOccurrences(of: #"[^\d\s]"#, with: "", options:     .regularExpression)
                            }
                            
                            south.append(TrainInfo(time: timestamp, line: route))
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.NStations = north
                            self?.SStations = south
                            self?.uptownTrainsTableView.reloadData()
                            self?.downtownTrainsTableView.reloadData()
                        }
                        
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
                return
            }
        }
        session.resume()
    }

}

extension String {
    
    func parseTime() -> String {
        let timePattern = #"(\d{2}:\d{2})"#
        
        do {
            let regex = try NSRegularExpression(pattern: timePattern, options: [])
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            
            if let match = matches.first {
                let range = Range(match.range, in: self)!
                let time = String(self[range])
                return time
            }
        } catch {
            print("Could not parse")
        }
        
        return ""
    }
}
