//
//  LocationVC.swift
//  PACKT-LetsEat
//
//  Created by Warba on 17/06/2023.
//

import UIKit

class LocationVC: UIViewController {

    @IBOutlet var tableView: UITableView!

    let manager = LocationDataManager()
    var selectedCity: LocationItem?

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

//MARK: - Extensions
private extension LocationVC {
    func initialize() {
        manager.fetch()
    }

    private func setCheckmark(for cell: UITableViewCell, location: LocationItem) {
        if selectedCity == location {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

extension LocationVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.numberOfLocationsItems()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let location = manager.locationItem(at: indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = location.cityAndState

        setCheckmark(for: cell, location: location)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedCity = manager.locationItem(at: indexPath.row)
            tableView.reloadData()
        }
    }


}
