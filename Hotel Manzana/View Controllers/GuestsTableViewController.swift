//
//  GuestsTableViewController.swift
//  Hotel Manzana
//
//  Created by Андрей on 05.07.2022.
//

import UIKit

class GuestsTableViewController: UITableViewController {
    // MARK: - Properties
    let guestCellManager = GuestCellManager()
    let dataManager = DataManager()
    var guests = [Guest]() {
        didSet {
            dataManager.saveGuests(guests)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guests = dataManager.loadGuests() ?? [Guest]()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditSegue" else { return }
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        
        var guest = guests[selectedPath.row]
        guest.editSegue = true
        let destination = segue.destination as! AddRegistrationTableViewController
        destination.guest = guest
    }
}

// MARK: - UITableViewDataSource
extension GuestsTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guest = guests[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestCell")! as! GuestCell
        
        guestCellManager.configure(cell, width: guest)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedGuest = guests.remove(at: sourceIndexPath.row)
        guests.insert(movedGuest, at: destinationIndexPath.row)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension GuestsTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            guests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            break
        case .none:
            break
        @unknown default:
            print(#line, #function, "Unknown case in file \(#file)")
            break
        }
        
    }
}

extension GuestsTableViewController {
    @IBAction  func unwind(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "doneSegue" else { return }
        
        let source = segue.source as! AddRegistrationTableViewController
        let guest = source.guest
        
        if let selectedPath = tableView.indexPathForSelectedRow {
            // Edited cell
            guests[selectedPath.row] = guest
            tableView.reloadRows(at: [selectedPath], with: .automatic)
        } else {
             // Added.cell
            let indexPath = IndexPath(row: guests.count, section: 0)
            guests.append(guest)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}
