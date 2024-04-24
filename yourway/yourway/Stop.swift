//
//  Stop.swift
//  yourway
//
//  Created by Riley Dou on 4/22/24.
//

import Foundation

struct Stop : Decodable {
    let data : [SubwayStation]
}

struct RouteData : Decodable  {
    let route : String
    let time : String
}

struct SubwayStation : Decodable {
    let N : [RouteData]
    let S : [RouteData]
    let routes : [String]
    let lastUpdate : String
    let id : String
    let location : [Double]
    let name : String
    let stops : [String: [Double]]
    
    enum CodingKeys: String, CodingKey {
        case N
        case S
        case routes
        case lastUpdate = "last_update"
        case id
        case location
        case name
        case stops
    }
}
