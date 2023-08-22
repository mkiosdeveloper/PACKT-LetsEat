//
//  ExploreVC.swift
//  PACKT-LetsEat
//
//  Created by Warba on 13/06/2023.
//

import Foundation
import UIKit

class ExploreVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    let manager = ExploreDataManager()
    var selectedCity: LocationItem?
    var headerView: ExploreHeaderView!

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {

            case Segue.locationList.rawValue:
                showLocationList(segue: segue)

            case Segue.restaurantList.rawValue:
                showRestaurantList(segue: segue)

            default:
                print("Segue not added")
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Segue.restaurantList.rawValue,
           selectedCity == nil {
            showLocationRequiredAlert()
            return false
        }
        return true
    }
}

// MARK: - Extensions

private extension ExploreVC {
    func initialize() {
        manager.fetch()
    }
    @IBAction func unwindLocationCancel(segue: UIStoryboardSegue) {

    }
    @IBAction func unwindLocationDone(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? LocationVC {
            selectedCity = viewController.selectedCity
            if let location = selectedCity {
                headerView.locationLabel.text = location.cityAndState
            }
        }
    }

    func showLocationRequiredAlert() {
        let alertController = UIAlertController(title: "Location Needed",
                                                message: "Please select a location",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func showLocationList(segue: UIStoryboardSegue) {
        guard let navController = segue.destination as? UINavigationController,
        let viewController = navController.topViewController as? LocationVC
        else { return }

        viewController.selectedCity = selectedCity
    }

    func showRestaurantList(segue: UIStoryboardSegue) {
        if let viewController = segue.destination as? RestaurantListVC,
           let city = selectedCity,
           let index = collectionView.indexPathsForSelectedItems?.first?.row {
            viewController.selectedCuisine = manager.exploreitem(at: index).name
            viewController.selectedCity = city
        }
    }


}

//MARK: - Extensions / TableView protocols
extension ExploreVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return manager.numberOfExploreItems()
    } // numberOfItemsInSection

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell",
                                                      for: indexPath) as! ExploreCell
        let exploreItem = manager.exploreitem(at: indexPath.row)
        cell.exploreNameLabel.text = exploreItem.name
        cell.exploreImageView.image = UIImage(named: exploreItem.image!)

        return cell
    } // cellForItemAt

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath)-> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath)
        headerView = header as? ExploreHeaderView
        return headerView
    } // viewForSupplementaryElementOfKind
}
