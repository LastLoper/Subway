//
//  Holiday.swift
//  Subway
//
//  Created by Walter J on 2022/11/28.
//

import Foundation

struct HolidayResponse: Decodable {
    let response: Response
//    enum CodingKeys: String, CodingKey {
//        case response = "response"
//    }
}

struct Response: Decodable {
    let body: Body
}

struct Body: Decodable {
    let items: Items
}

struct Items: Decodable {
    let item: [Item]
}

struct Item: Decodable {
    let dateKind: String
    let dateName: String
    let isHoliday: String
}
