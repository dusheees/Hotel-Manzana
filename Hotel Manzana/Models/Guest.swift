//
//  Guest.swift
//  Hotel Manzana
//
//  Created by Андрей on 05.07.2022.
//

import Foundation
import UIKit

struct Guest: Codable {
    var firstName: String
    var lastName: String
    var emailAdress: String
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    var roomType: RoomType
    var wifi: Bool
    var editSegue: Bool = false
    
    init(firstName: String = "",
         lastName: String = "",
         emailAdress: String = "",
         checkInDate: Date = Date(),
         checkOutDate: Date = Date(),
         numberOfAdults: Int = 0,
         numberOfChildren: Int = 0,
         roomType: RoomType = RoomType(id: -1, name: "Not Set", shortName: "", price: 0),
         wifi: Bool = false
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAdress = emailAdress
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.numberOfAdults = numberOfAdults
        self.numberOfChildren = numberOfChildren
        self.roomType = roomType
        self.wifi = wifi
    }
}
