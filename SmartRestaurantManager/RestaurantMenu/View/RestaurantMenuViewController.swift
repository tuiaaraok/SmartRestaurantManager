//
//  RestaurantMenuViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit
import Combine

class RestaurantMenuViewController: UIViewController {

    @IBOutlet weak var searchTextField: PaddingTextField!
    @IBOutlet weak var productTypeCollectionView: UICollectionView!
    @IBOutlet weak var productsTableView: UITableView!
    private let viewModel = MenuViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationMenuButton()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func setupUI() {
        searchTextField.setupRightViewIcon(.searchIcon, size: CGSize(width: 40, height: 40))
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        searchTextField.layer.cornerRadius = 15
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 120, height: 44)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        productTypeCollectionView.collectionViewLayout = layout
        productTypeCollectionView.register(UINib(nibName: "ProductTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductTypeCollectionViewCell")
        productTypeCollectionView.delegate = self
        productTypeCollectionView.dataSource = self
        productsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        productsTableView.delegate = self
        productsTableView.dataSource = self
        searchTextField.delegate = self
    }
    
    func subscribe() {
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.productTypeCollectionView.selectItem(at: IndexPath(item: self.viewModel.selectedType, section: 0), animated: true, scrollPosition: .left)
                self.productsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openProductForm() {
        let productFormVC = ProductFormViewController(nibName: "ProductFormViewController", bundle: nil)
        productFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(productFormVC, animated: true)
    }
}

extension RestaurantMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ProductType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductTypeCollectionViewCell", for: indexPath) as! ProductTypeCollectionViewCell
        cell.configure(name: ProductType.allCases[indexPath.item].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.filter(by: indexPath.item)
    }
}

extension RestaurantMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        cell.configure(product: viewModel.products[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        8
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.viewModel.remove(by: viewModel.products[indexPath.section].id) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorAlert(message: error.localizedDescription)
                } else {
                    self.viewModel.fetchData()
                    handler(true)
                }
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            ProductFormViewModel.shared.product = self.viewModel.products[indexPath.section]
            self.openProductForm()
        }
        deleteAction.backgroundColor = .white
        deleteAction.image = UIImage.removeIcon
        editAction.backgroundColor = .white
        editAction.image = .editIcon
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension RestaurantMenuViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.search(by: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

enum ProductType: String, CaseIterable {
    case all = "All"
    case mainDishes = "Main dishes"
    case snacks = "Snacks"
    case drinks = "Drinks"
}
