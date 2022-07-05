//
//  AppRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Андрей on 05.07.2022.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var roomTypeLabel: UILabel!
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    var guest = Guest()
    
    let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)

    var isCheckInDatePickerShown: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    var roomType: RoomType?
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        if guest.editSegue == true {
            updateUI()
        } else {
            updateDateViews()
            updateNumberOfGuests()
            updateRoomType()
        }
        fillingCheck()
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SelectRoomType" else {
            saveGuest()
            return
        }
        let destination = segue.destination as! SelectRoomTypeTableViewController
        destination.delegate = self
        if guest.editSegue == true {
            destination.roomType = guest.roomType
        } else {
            destination.roomType = roomType
        }
    }
    
    // MARK: - UI Methods
    func fillingCheck() {
        if firstNameTextField.text != "" && lastNameTextField.text != ""
        && emailTextField.text != "" && roomTypeLabel.text != "Not Set" {
            doneBarButtonItem.isEnabled = true
        } else {
            doneBarButtonItem.isEnabled = false
        }
        
        // email input check
        if validateEmail(candidate: emailTextField.text!) || emailTextField.text == "" {
            emailTextField.backgroundColor = .clear
        } else {
            emailTextField.backgroundColor = .red
            doneBarButtonItem.isEnabled = false
        }
        
        // firstNameTextField input check
        if validateName(candidate: firstNameTextField.text!) {
            firstNameTextField.backgroundColor = .clear
        } else {
            firstNameTextField.backgroundColor = .red
            doneBarButtonItem.isEnabled = false
        }
        
        // lastNameTextField input check
        if validateName(candidate: lastNameTextField.text!) {
            lastNameTextField.backgroundColor = .clear
        } else {
            lastNameTextField.backgroundColor = .red
            doneBarButtonItem.isEnabled = false
        }
    }
    
    func updateUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        
        firstNameTextField.text = guest.firstName
        lastNameTextField.text = guest.lastName
        emailTextField.text = guest.emailAdress
        checkInDatePicker.date = guest.checkInDate
        checkInDateLabel.text = dateFormatter.string(from: guest.checkInDate)
        checkOutDatePicker.date = guest.checkOutDate
        checkOutDateLabel.text = dateFormatter.string(from: guest.checkOutDate)
        numberOfAdultsLabel.text = String(guest.numberOfAdults)
        numberOfChildrenLabel.text = String(guest.numberOfChildren)
        roomTypeLabel.text = guest.roomType.name
        wifiSwitch.isOn = guest.wifi
    }
    
    func saveGuest() {
        guest.firstName = firstNameTextField.text ?? ""
        guest.lastName = lastNameTextField.text ?? ""
        guest.emailAdress = emailTextField.text ?? ""
        guest.checkInDate = checkInDatePicker.date
        guest.checkOutDate = checkOutDatePicker.date
        guest.numberOfAdults = Int(numberOfAdultsStepper.value)
        guest.numberOfChildren = Int(numberOfChildrenStepper.value)
        guest.roomType = roomType ?? RoomType(id: -1, name: "Not Set", shortName: "", price: 0)
        guest.wifi = wifiSwitch.isOn
    }
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        numberOfAdultsLabel.text = "\(numberOfAdults)"
        numberOfChildrenLabel.text = "\(numberOfChildren)"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    // MARK: - Actions
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func stapperValueChanged() {
        updateNumberOfGuests()
    }
    
    // MARK: - Targets
    @objc func textFieldDidChange() {
        fillingCheck()
    }
}

// MARK: - UITableViewDataSource
extension AddRegistrationTableViewController /*: UITableViewDataSource*/ {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerIndexPath:
            return isCheckInDatePickerShown ? UITableView.automaticDimension : 0
        case checkOutDatePickerIndexPath:
            return isCheckOutDatePickerShown ? UITableView.automaticDimension : 0
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: - UITableViewDelegate
extension AddRegistrationTableViewController /*: UITableViewDelegate*/ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case checkInDateLabelIndexPath:
            isCheckInDatePickerShown.toggle()
            isCheckOutDatePickerShown = false
        case checkOutDateLabelIndexPath:
            isCheckOutDatePickerShown.toggle()
            isCheckInDatePickerShown = false
        default:
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerProtocol {
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        fillingCheck()
    }
}

// MARK: - input check
extension AddRegistrationTableViewController {
    func validateEmail(candidate: String) -> Bool {
     let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func validateName(candidate: String) -> Bool {
        for chr in candidate {
              if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                 return false
              }
           }
        return true
    }
}
