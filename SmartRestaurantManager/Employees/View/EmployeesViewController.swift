//
//  EmployeesViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import UIKit
import Combine

class EmployeesViewController: UIViewController {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var positionsCollectionView: UICollectionView!
    @IBOutlet weak var employeesTableView: UITableView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let viewModel = EmployeesViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationMenuButton()
        setNavigationTitle(title: "Employee schedule")
        employeesTableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableViewCell")
        employeesTableView.delegate = self
        employeesTableView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 120, height: 44)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        positionsCollectionView.collectionViewLayout = layout
        positionsCollectionView.register(UINib(nibName: "ProductTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductTypeCollectionViewCell")
        positionsCollectionView.delegate = self
        positionsCollectionView.dataSource = self
        textField.isHidden = true
        view.addSubview(textField)
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        textField.inputView = datePicker
        tapGesture.delegate = self
    }
    
    func subscribe() {
        viewModel.$employees
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dateButton.setTitle(self.viewModel.selectedDate.toStringFormat(), for: .normal)
                self.positionsCollectionView.selectItem(at: IndexPath(item: self.viewModel.selectedPosition, section: 0), animated: true, scrollPosition: .left)
                self.employeesTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func datePickerValueChanged() {
        viewModel.chooseDate(date: datePicker.date.stripTime())
        view.endEditing(true)
    }
    
    func openEmployeeForm() {
        let employeeFormVC = EmployeeFormViewController(nibName: "EmployeeFormViewController", bundle: nil)
        employeeFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(employeeFormVC, animated: true)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func chooseDate(_ sender: UIButton) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func clickedAdd(_ sender: UIButton) {
        openEmployeeForm()
    }
    
    deinit {
        viewModel.clear()
    }
}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        cell.configure(employee: viewModel.employees[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EmployeeFormViewModel.shared.employee = viewModel.employees[indexPath.row]
        openEmployeeForm()
    }
}

extension EmployeesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        EmployeePosition.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductTypeCollectionViewCell", for: indexPath) as! ProductTypeCollectionViewCell
        cell.configure(name: EmployeePosition.allCases[indexPath.item].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.choosePosition(position: indexPath.item)
    }
}

extension EmployeesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: view)
        if let touchedView = view.hitTest(touchLocation, with: nil) {
            if touchedView.isDescendant(of: positionsCollectionView) || touchedView.isDescendant(of: employeesTableView) {
                return false
            }
        }
        return true
    }
}

enum EmployeePosition: String, CaseIterable {
    case all = "All"
    case bar = "Bar"
    case hall = "Hall"
    case kitchen = "Kitchen"
    case cleaning = "Cleaning"    
}
