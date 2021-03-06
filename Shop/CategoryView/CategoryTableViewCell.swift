//
//  CategoryTableViewCell.swift
//  Shop
//
//  Created by Mahutin Aleksei on 01/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

@IBDesignable
class CategoryTableViewCell: UITableViewCell, InterfaceIsDark {
    
    var intefaceIsDark: Bool { return traitCollection.userInterfaceStyle == .dark }
    
    
    private let picture = UIImageView()
    private let label = UILabel()
    private let indicator = UIActivityIndicatorView()
    private let loading = UIActivityIndicatorView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func didMoveToSuperview() {
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        picture.contentMode = .scaleAspectFit
        for elem in [picture,label,indicator,loading] {
            addSubview(elem)
            elem.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            picture.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            picture.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -12),
            picture.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 12),
            picture.widthAnchor.constraint(equalTo: picture.heightAnchor),
            indicator.centerXAnchor.constraint(equalTo: picture.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: picture.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -55),
            label.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 32),
            label.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -32),
            loading.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    func setText(text: String) {
        label.text = text
        label.layoutIfNeeded()
    }
    
    func setPicture(url: String) {
        indicator.isHidden = false
        indicator.startAnimating()
        //try load from realm
        if let oldImage = PersistanceData.shared.loadImage(url: url) {
            self.indicator.stopAnimating()
            if intefaceIsDark {
                self.picture.image = oldImage.inverseImage(cgResult: false)
            }else{
                self.picture.image = oldImage
            }
            self.picture.layoutIfNeeded()
            return
        }
        
        //try load from network
        DataLoader.shared.getImageFromWeb(DataNow.shared.url + url, closure: {
            image in
            if image != nil {
                self.picture.image = image!
                PersistanceData.shared.saveImage(image: image!, url: url)
            }else{
                self.picture.image = UIImage(named: "NoImg")
                PersistanceData.shared.saveFailData(url: url)
            }
            if self.intefaceIsDark {
                self.picture.image = self.picture.image!.inverseImage(cgResult: false)
            }
            self.indicator.stopAnimating()
            self.picture.layoutIfNeeded()
        })
    }
    
    func load(isLoad: Bool) {
        switch isLoad {
        case true:
            for elem in [picture,label,indicator] {
                elem.isHidden = true
            }
            loading.startAnimating()
            loading.isHidden = false
            
        case false:
            for elem in [picture,label] {
                elem.isHidden = false
            }
            loading.stopAnimating()
            loading.isHidden = true
        }
    }

    
}

extension UIImage {
func inverseImage(cgResult: Bool) -> UIImage? {
    let coreImage = UIKit.CIImage(image: self)
    guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
    filter.setValue(coreImage, forKey: kCIInputImageKey)
    guard let result = filter.value(forKey: kCIOutputImageKey) as? UIKit.CIImage else { return nil }
    if cgResult { // I've found that UIImage's that are based on CIImages don't work with a lot of calls properly
        return UIImage(cgImage: CIContext(options: nil).createCGImage(result, from: result.extent)!)
    }
    return UIImage(ciImage: result)
  }
}
