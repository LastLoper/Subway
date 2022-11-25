//
//  StationResponse.swift
//  Subway
//
//  Created by WalterCho on 2022/11/25.
//

import Foundation

struct StationResponse: Decodable {
    var stations: [Station] {
        searchInfo.row
    }
        
    struct SearchInfoBySubwayNameService: Decodable {
        var row: [Station] = []
    }
    
    private let searchInfo: SearchInfoBySubwayNameService
    enum CodingKeys: String, CodingKey {
        case searchInfo = "SearchInfoBySubwayNameService"
    }
}

struct Station: Decodable {
    let stationName: String
    let lineNumber: String
    
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
}
