//
//  FilterCell.swift
//  PACKT-LetsEat
//
//  Created by Warba on 25/06/2023.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.clipsToBounds = true
    }
}

//MARK: - Extensions

extension FilterCell: ImageFiltering {
    func set(filterItem: FilterItem, imageForThumbnail: UIImage) {
        if let filter = filterItem.filter {
            if filter != "None" {
                let filteredImage = apply(filter: filter, originalImage: imageForThumbnail)
                thumbnailImageView.image = filteredImage
                nameLabel.text = filterItem.filter
            } else {
                thumbnailImageView.image = imageForThumbnail
            }
        }
    } // set()
} // FilterCell
