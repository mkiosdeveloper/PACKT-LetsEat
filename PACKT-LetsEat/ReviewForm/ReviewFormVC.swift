//
//  ReviewFormVCTableViewController.swift
//  PACKT-LetsEat
//
//  Created by Warba on 25/06/2023.
//

import UIKit
import OSLog

class ReviewFormVC: UITableViewController {

    var logger = Logger(subsystem: "samplemkdev.PACKT-LetsEat", category: "ReviewFormVC")

    var selectedRestaurantID: Int?

    @IBOutlet var ratingsView: RatingsView!

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var reviewTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        print("selectedRestaurantID⬇\n\(selectedRestaurantID as Any)")

    }
}

//MARK: - Extensions
private extension ReviewFormVC {
    @IBAction func onSaveTapped(_ sender: Any) {
        var reviewItem = ReviewItem()
        reviewItem.rating = ratingsView.rating
        reviewItem.title = titleTextField.text
        reviewItem.name = nameTextField.text
        reviewItem.customerReview = reviewTextView.text
        if let selRestID = selectedRestaurantID {
            reviewItem.restaurantID = Int64(selRestID)
        }
        CoreDataManager.shared.addReview(reviewItem)
        dismiss(animated: true, completion: nil)
    }
}


extension ReviewFormVC {

}
