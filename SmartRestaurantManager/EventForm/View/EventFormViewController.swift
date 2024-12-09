//
//  EventFormViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import UIKit
import Combine

class EventFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var guestsTextField: BaseTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var startTimeTextField: BaseTextField!
    @IBOutlet weak var endTimeTextField: BaseTextField!
    @IBOutlet weak var saveButton: BaseButton!
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let datePicker = UIDatePicker()
    private let viewModel = EventFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        setNavigationTitle(title: "Add event")
        setNavigationBackButton()
        titleLabels.forEach({ $0.font = .regular(size: 20) })
        nameTextField.delegate = self
        guestsTextField.delegate = self
        startDatePicker.locale = NSLocale.current
        startDatePicker.datePickerMode = .time
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
        startTimeTextField.inputView = startDatePicker
        
        endDatePicker.locale = NSLocale.current
        endDatePicker.datePickerMode = .time
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged), for: .valueChanged)
        endTimeTextField.inputView = endDatePicker
        
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateShiftPickerValueChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    func subscribe() {
        viewModel.$event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                self.nameTextField.text = event.name
                if let guests = event.numberGuests {
                    self.guestsTextField.text = "\(guests)"
                }
                self.dateTextField.text = event.date?.toString()
                self.startTimeTextField.text = event.startTime?.toString(format: "HH:mm")
                self.endTimeTextField.text = event.endTime?.toString(format: "HH:mm")
                self.saveButton.isEnabled = (event.name.checkValidation() && event.numberGuests != nil && event.date != nil && event.startTime != nil && event.endTime != nil)
            }
            .store(in: &cancellables)
    }
    
    @objc func startDatePickerValueChanged() {
        viewModel.event.startTime = startDatePicker.date
    }
    
    @objc func endDatePickerValueChanged() {
        viewModel.event.endTime = endDatePicker.date
    }
    
    @objc func dateShiftPickerValueChanged() {
        viewModel.event.date = datePicker.date.stripTime()
        view.endEditing(true)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension EventFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.event.name = textField.text
        } else if textField == guestsTextField {
            viewModel.event.numberGuests = Int(textField.text ?? "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == guestsTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
