//
//  DataManager.swift
//  Hotel Manzana
//
//  Created by Андрей on 05.07.2022.
//

import Foundation

class DataManager {
    var archiveURL: URL? {
        guard let documetDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documetDirector.appendingPathComponent("Hotel Manzana").appendingPathExtension("plist")
    }
    
    func loadGuests() -> [Guest]? {
        guard let archiveURL = archiveURL else { return nil }
        guard let encodedGuest = try? Data(contentsOf: archiveURL) else { return nil }
        
        let decoder = PropertyListDecoder()
        return try? decoder.decode([Guest].self, from: encodedGuest)
    }
    
    func saveGuests(_ emojis: [Guest]) {
        guard let archiveURL = archiveURL else { return }

        let encoder = PropertyListEncoder()
        guard let encodedGuest = try? encoder.encode(emojis) else { return }
        
        try? encodedGuest.write(to: archiveURL, options: .noFileProtection)
    }
}

