//
//  DetailViewController.swift
//  yourway
//
//  Created by Riley Dou on 4/23/24.
//

import UIKit

class DetailViewController: UIViewController {
    

    @IBOutlet weak var trainLineN: UITextView!
    @IBOutlet weak var trainTimeN: UITextView!
    @IBOutlet weak var trainLineS: UITextView!
    @IBOutlet weak var trainTimeS: UITextView!
    var stop: Station!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchStops()
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
                
                // Iterate through all 5 stations
                for station in stationData {
                    if (station.name == self.stop.name) {
                        
                        // Display next train
                        if let currNStation = station.N.first {
                            
                            let timestamp = currNStation.time.parseTime()

                            // Parse time
                            var route = currNStation.route
                            let charset = CharacterSet(charactersIn: "1234567")
                            if route.rangeOfCharacter(from: charset) != nil {
                                route = currNStation.route.replacingOccurrences(of: #"[^\d\s]"#, with: "", options:     .regularExpression)
                                }
                            
                            DispatchQueue.main.async { [weak self] in
                                self?.trainTimeN.text = timestamp
                                self?.trainLineN.text = route
                            }
                        }
                        
                        if let currSStation = station.S.first {
                            let timestamp = currSStation.time.parseTime()
                            
                            var route = currSStation.route
                            let charset = CharacterSet(charactersIn: "1234567")
                            if route.rangeOfCharacter(from: charset) != nil {
                                route = currSStation.route.replacingOccurrences(of: #"[^\d\s]"#, with: "", options:     .regularExpression)
                            }
                            
                            DispatchQueue.main.async { [weak self] in
                                self?.trainTimeS.text = timestamp
                                self?.trainLineS.text = route
                            }
                        }
                    }
                }

            } catch {
                print("❌ Error decoding JSON: \(error)")
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
