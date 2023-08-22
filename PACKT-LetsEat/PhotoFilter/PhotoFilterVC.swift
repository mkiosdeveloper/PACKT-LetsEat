//
//  PhotoFilterVC.swift
//  PACKT-LetsEat
//
//  Created by Warba on 25/06/2023.
//

import UIKit
import AVFoundation

class PhotoFilterVC: UIViewController {

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!

    private let manager = FilterDataManager()

    private var mainImage: UIImage?
    private var thumbnail: UIImage?
    private var filters: [FilterItem] = []

    var selectedRestaurantID: Int?

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

//MARK: - Extension
private extension PhotoFilterVC {
    func initialize() {
        setupCollectionView()
        checkSource()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8

        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func checkSource() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)

        switch cameraAuthStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: cameraMediaType) { isGranted in
                    if isGranted {
                        DispatchQueue.main.async {
                            self.showCameraUI()
                        }
                    }
                } // requestAccess
            case .authorized:
                self.showCameraUI()

            default:
                break
        }
    }
    func showApplyFilterInterface() {
        filters = manager.fetch()
        if let mainImage = self.mainImage {
            mainImageView.image = mainImage
            collectionView.reloadData()
        }
    }
    func saveSelectedPhoto() {
        if let mainImage = self.mainImageView.image {
            var restPhotoItem = RestaurantPhotoItem()
            restPhotoItem.date = Date()
            //restPhotoItem.photo = mainImage.preparingThumbnail(of: CGSize(width: 100, height: 100))
            if let selRestID = selectedRestaurantID {
                restPhotoItem.restaurantID = Int64(selRestID)
            }
            CoreDataManager.shared.addPhoto(restPhotoItem)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onPhotoTapped(_ sender: Any) {
        checkSource()
    }
    @IBAction func onSaveTapped(_ sender: Any) {
        saveSelectedPhoto()
    }
}

//MARK: UIKit related extensions
extension PhotoFilterVC: UICollectionViewDataSource,
                         UICollectionViewDelegate,
                         UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell",
                                                      for: indexPath) as! FilterCell
        let filterItem = filters[indexPath.row]

        if let thumbnail {
            cell.set(filterItem: filterItem, imageForThumbnail: thumbnail)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let filterItem = self.filters[indexPath.row]
        filterMainImage(filterItem: filterItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = collectionView.frame.size.height
        let topInset = 14.0
        let cellHeight = collectionViewHeight - topInset

        return CGSize(width: 150, height: cellHeight)
    }
}

extension PhotoFilterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showCameraUI() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        #if targetEnvironment(simulator)
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        #else
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.showsCameraControls = true
        #endif
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            //self.thumbnail = selectedImage.preparingThumbnail(of: CGSize(width: 100, height: 100))

            let mainImageViewSize = mainImageView.frame.size
           // self.mainImage = selectedImage.preparingThumbnail(of: mainImageViewSize)
        }
        picker.dismiss(animated: true) {
            self.showApplyFilterInterface()
        }
    }
}

extension PhotoFilterVC: ImageFiltering {
    func filterMainImage(filterItem: FilterItem) {
        if let mainImage,
           let filter = filterItem.filter {
            if filter != "None" {
                mainImageView.image = self.apply(filter: filter, originalImage: mainImage)
            } else {
                mainImageView.image = mainImage
            }
        }
    }
}
