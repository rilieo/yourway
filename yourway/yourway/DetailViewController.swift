//
//  DetailViewController.swift
//  yourway
//
//  Created by Riley Dou on 4/23/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var trainLine: UITextView!
    @IBOutlet weak var arrivalTime: UITextView!
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
                let timePattern = #"(\d{2}:\d{2})"#
                let charPattern = #"[^\d\s]"#
                
                // Iterate through all 5 stations
                for station in stationData {
                    if (station.name == self.stop.name) {
                        
                        // Display next train
                        if let currStation = station.N.first {
                            let timestamp = currStation.time
                            
                            do {
                                // Parse time
                                let regex = try NSRegularExpression(pattern: timePattern, options: [])
                                let matches = regex.matches(in: timestamp, options: [], range: NSRange(location: 0, length: timestamp.utf16.count))
                                
                                if let match = matches.first {
                                    let range = Range(match.range, in: timestamp)!
                                    let time = String(timestamp[range])
                                    
                                    // Remove any random characters in number lines
                                    var route = currStation.route
                                    let charset = CharacterSet(charactersIn: "1234567")
                                    if route.rangeOfCharacter(from: charset) != nil {
                                        route = currStation.route.replacingOccurrences(of: charPattern, with: "", options: .regularExpression)
                                    }

                                    DispatchQueue.main.async { [weak self] in
                                        self?.arrivalTime.text = time
                                        self?.trainLine.text = route
                                    }
                                    
                                } else {
                                    print("Time not found.")
                                }
                            } catch {
                                print("Regex error:", error)
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
