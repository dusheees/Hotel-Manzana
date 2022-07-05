//
//  GuestCellManager.swift
//  Hotel Manzana
//
//  Created by Андрей on 05.07.2022.
//

import UIKit

struct GuestCellManager {
    func configure(_ cell: GuestCell, width guest: Guest) {
        cell.nameLabel.text = guest.firstName + guest.lastName
        cell.emailAdressLabel.text = guest.emailAdress
    }
}
