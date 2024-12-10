//
//  EmployeeFormViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import UIKit
import DropDown
import Combine

class EmployeeFormViewController: UIViewController {
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var positionButton: UIButton!
    @IBOutlet weak var startShiftTextField: BaseTextField!
    @IBOutlet weak var endShiftTextField: BaseTextField!
    @IBOutlet weak var dateShiftTextField: BaseTextField!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var createButton: BaseButton!
    private let dropDown = DropDown()
    private let viewModel = EmployeeFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let dateShiftPicker = UIDatePicker()
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        self.dropDown.width = self.positionButton.bounds.width
        self.dropDown.bottomOffset = CGPoint(x: self.positionButton.frame.minX, y: self.positionButton.frame.maxY + 2)
    }
    
    func setupUI() {
        setNavigationBackButton()
        setNavigationTitle(title: "Add shift")
        titleLabels.forEach({ $0.font = .regular(size: 20) })
        positionButton.layer.cornerRadius = 10
        positionButton.layer.borderWidth = 2
        positionButton.layer.borderColor = UIColor.black.cgColor
        nameTextField.delegate = self
        
        var data: [String] = EmployeePosition.allCases.map { $0.rawValue }
        data.removeFirst()
        dropDown.backgroundColor = .white
        dropDown.layer.cornerRadius = 16
        dropDown.dataSource = data
        dropDown.anchorView = view
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 18) ?? .boldSystemFont(ofSize: 18)
        dropDown.addShadow()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            viewModel.employee.position = index + 1
            self.dropDownImageView.isHighlighted = false
        }
        
        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.dropDownImageView.isHighlighted = false
        }
        
        startDatePicker.locale = NSLocale.current
        startDatePicker.datePickerMode = .time
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
        startShiftTextField.inputView = startDatePicker
        
        endDatePicker.locale = NSLocale.current
        endDatePicker.datePickerMode = .time
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged), for: .valueChanged)
        endShiftTextField.inputView = endDatePicker
        
        dateShiftPicker.locale = NSLocale.current
        dateShiftPicker.datePickerMode = .date
        dateShiftPicker.preferredDatePickerStyle = .inline
        dateShiftPicker.addTarget(self, action: #selector(dateShiftPickerValueChanged), for: .valueChanged)
        dateShiftTextField.inputView = dateShiftPicker
    }
    
    func subscribe() {
        viewModel.$employee
            .receive(on: DispatchQueue.main)
            .sink { [weak self] employee in
                guard let self = self else { return }
                self.nameTextField.text = employee.name
                if let position = employee.position {
                    self.positionButton.setTitle(EmployeePosition.allCases[position].rawValue, for: .normal)
                } else {
                    self.positionButton.setTitle(nil, for: .normal)
                }
                self.startShiftTextField.text = employee.startOfShift?.toString(format: "HH:mm")
                self.endShiftTextField.text = employee.endOfShift?.toString(format: "HH:mm")
                self.dateShiftTextField.text = employee.datesOfShift?.toString()
                self.createButton.isEnabled = (employee.name.checkValidation() && employee.position != nil && employee.datesOfShift != nil && employee.startOfShift != nil && employee.endOfShift != nil)
            }
            .store(in: &cancellables)
    }
    
    @objc func startDatePickerValueChanged() {
        viewModel.employee.startOfShift = startDatePicker.date
    }
    
    @objc func endDatePickerValueChanged() {
        viewModel.employee.endOfShift = endDatePicker.date
    }
    
    @objc func dateShiftPickerValueChanged() {
        viewModel.employee.datesOfShift = dateShiftPicker.date.stripTime()
        view.endEditing(true)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func choosePosition(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func clickedCreate(_ sender: BaseButton) {
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

extension EmployeeFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.employee.name = textField.text
        }
    }
}
