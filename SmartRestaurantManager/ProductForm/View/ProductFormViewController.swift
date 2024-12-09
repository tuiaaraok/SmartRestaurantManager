//
//  ProductFormViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit
import Cosmos
import DropDown
import Combine
import PhotosUI

class ProductFormViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var priceTextField: PricesTextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var descriptionTextView: PaddingTextView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    private let dropDown = DropDown()
    private let viewModel = ProductFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        self.dropDown.width = self.categoryButton.bounds.width
        self.dropDown.bottomOffset = CGPoint(x: self.categoryButton.frame.minX, y: self.categoryButton.frame.maxY + 2)
    }
    
    func setupUI() {
        setNavigationTitle(title: "Add a dish")
        setNavigationBackButton()
        titleLabels.forEach({ $0.font = .regular(size: 20) })
        descriptionTextView.font = .regular(size: 18)
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        categoryButton.layer.cornerRadius = 10
        categoryButton.layer.borderWidth = 2
        categoryButton.layer.borderColor = UIColor.black.cgColor
        photoButton.layer.cornerRadius = 10
        photoButton.layer.borderWidth = 2
        photoButton.layer.borderColor = UIColor.black.cgColor
        photoButton.layer.masksToBounds = true
        nameTextField.delegate = self
        priceTextField.baseDelegate = self
        descriptionTextView.delegate = self
        tapGesture.delegate = self
        
        var data: [String] = ProductType.allCases.map { $0.rawValue }
        data.removeFirst()
        dropDown.backgroundColor = .white
        dropDown.layer.cornerRadius = 16
        dropDown.dataSource = data
        dropDown.anchorView = contentView
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 18) ?? .boldSystemFont(ofSize: 18)
        dropDown.addShadow()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            viewModel.product.category = index + 1
            self.dropDownImageView.isHighlighted = false
        }
        
        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.dropDownImageView.isHighlighted = false
        }
        
        cosmosView.didTouchCosmos = { [weak self] value in
            guard let self = self else { return }
            self.viewModel.product.rating = value
        }
    }
    
    func subscribe() {
        viewModel.$product
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                guard let self = self else { return }
                self.nameTextField.text = product.name
                self.priceTextField.text = product.price
                if let selectedCategory = product.category {
                    self.categoryButton.setTitle(ProductType.allCases[selectedCategory].rawValue, for: .normal)
                } else {
                    self.categoryButton.setTitle(nil, for: .normal)
                }
                self.descriptionTextView.text = product.info
                self.cosmosView.rating = product.rating
                if let data = product.photo {
                    self.photoButton.setImage(UIImage(data: data), for: .normal)
                } else {
                    self.photoButton.setImage(.imagePlaceholder, for: .normal)
                }
                self.saveButton.isEnabled = (product.name.checkValidation() && product.price != nil && product.category != nil && product.photo != nil && product.info != nil)
            }
            .store(in: &cancellables)
    }

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func chooseCategory(_ sender: UIButton) {
        dropDown.show()
        dropDownImageView.isHighlighted = !dropDown.isHidden
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.requestCameraAccess()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.requestPhotoLibraryAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(actionSheet, animated: true, completion: nil)
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

extension ProductFormViewController: UITextFieldDelegate, UITextViewDelegate, PriceTextFielddDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.product.name = textField.text
        } else if textField == priceTextField {
            viewModel.product.price = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.product.info = textView.text
    }
}

extension ProductFormViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(view.hitTest(touch.location(in: view), with: nil)?.isDescendant(of: cosmosView) == true)
    }
}

extension ProductFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func requestCameraAccess() {
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
            case .authorized:
                openCamera()
            case .denied, .restricted:
                showSettingsAlert()
            @unknown default:
                break
            }
        }
        
        private func requestPhotoLibraryAccess() {
            let photoStatus = PHPhotoLibrary.authorizationStatus()
            switch photoStatus {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.openPhotoLibrary()
                    }
                }
            case .authorized:
                openPhotoLibrary()
            case .denied, .restricted:
                showSettingsAlert()
            case .limited:
                break
            @unknown default:
                break
            }
        }
        
        private func openCamera() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func openPhotoLibrary() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func showSettingsAlert() {
            let alert = UIAlertController(title: "Access Needed", message: "Please allow access in Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                photoButton.setImage(editedImage, for: .normal)
            } else if let originalImage = info[.originalImage] as? UIImage {
                photoButton.setImage(originalImage, for: .normal)
            }
            if let imageData = photoButton.imageView?.image?.jpegData(compressionQuality: 1.0) {
                let data = imageData
                viewModel.product.photo = data
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
