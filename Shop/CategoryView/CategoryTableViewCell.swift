//
//  CategoryTableViewCell.swift
//  Shop
//
//  Created by Mahutin Aleksei on 01/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

@IBDesignable
class CategoryTableViewCell: UITableViewCell {
    
    private let picture = UIImageView()
    private let label = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func didMoveToSuperview() {
        label.textAlignment = .center
        picture.contentMode = .scaleAspectFit
        addSubview(picture)
        addSubview(label)
        setConstraint()
    }
    
    private func setConstraint() {
        picture.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            picture.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            picture.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -12),
            picture.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 12),
            picture.widthAnchor.constraint(equalTo: picture.heightAnchor),
            label.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -55),
            label.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 32),
            label.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -32)
        ])
    }
    func setText(text: String) {
        label.text = text
        label.layoutIfNeeded()
    }
    
    func setPicture(picture: UIImage) {
        self.picture.image = picture
        self.picture.layoutIfNeeded()

    }

}
