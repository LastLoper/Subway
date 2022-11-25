//
//  StationArrivalDataResponse.swift
//  Subway
//
//  Created by WalterCho on 2022/11/25.
//

import Foundation

struct StationArrivalDataResponse: Decodable {
    var realtimeArrivalList: [RealTimeArrival] = []
    
    struct RealTimeArrival: Decodable {
        let line: String
        let remainTime: String      //도착까지 남은 시간 or 전역 출발 시간
        let currentStationName: String
        
        enum CodingKeys: String, CodingKey {
            case line = "trainLineNm"
            case remainTime = "arvlMsg2"
            case currentStationName = "arvlMsg3"
        }
    }
}
