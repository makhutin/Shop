//
//  CartItemController.swift
//  Shop
//
//  Created by Mahutin Aleksei on 04/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class CartItemController: UIViewController, InterfaceIsDark {
    
    var intefaceIsDark: Bool { return traitCollection.userInterfaceStyle == .dark }
    
    var descriptionData = ""
    var nameData = ""
    var priceData = "" {
        didSet {
            if priceData.count > 3 {
                let end = priceData.reversed()[0...2].reversed()
                let startIndex = priceData.index(priceData.startIndex, offsetBy: 0)
                let endIndex = priceData.index(priceData.startIndex, offsetBy: priceData.count - 4)
                let start = priceData[startIndex...endIndex]
                priceData = start + " " + end
            }
        }
    }
    var imageUrl = [String]()
    
    private let mainScrollView = UIScrollView()
    private let mainView = UIView()
    private let images = UIScrollView()
    private let name = UILabel()
    private let abouItem = UILabel()
    private let buyButton = UIButton()
    private let backButton = UIButton()
    private let toBuyList = UIButton()
    private let pageControl = CustomPageControl()
    private let lineGray = UIView()
    
    private let priceStack = UIStackView()
    private let price = UILabel()
    private let priceLabel = UILabel()
    
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            return statusBarHeight
        }else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    var hasNoth: Bool {
        return statusBarHeight >= 44 && !UIDevice.current.orientation.isLandscape
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        mainScrollViewInit()
        imagesInit()
        nameInit()
        lineInit()
        priceInit()
        buttonInit()
        abouItemInit()
        toBouyListButtonInit()
        backButtonInit()
        constraintInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateScrollViewHeight()
        imagesLoad()
    }
    
    private func constraintInit() {
        
        NSLayoutConstraint.activate([
            //mainScrolView
            mainScrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: hasNoth ? -10 : -statusBarHeight),
            mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            //images
            images.topAnchor.constraint(equalTo: mainView.topAnchor),
            images.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            images.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            images.heightAnchor.constraint(equalTo: images.widthAnchor),
            //pageControl
            pageControl.centerXAnchor.constraint(equalTo: images.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: images.bottomAnchor, constant: -20),
            //name
            name.topAnchor.constraint(equalTo: images.bottomAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            //line
            lineGray.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 1),
            lineGray.heightAnchor.constraint(equalToConstant: 1),
            lineGray.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 19),
            lineGray.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -19),
            //price Stack
            priceStack.topAnchor.constraint(equalTo: lineGray.bottomAnchor, constant: 1),
            priceStack.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 19),
            priceStack.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -19),
            //buyButton
            buyButton.topAnchor.constraint(equalTo: priceStack.bottomAnchor, constant: 15),
            buyButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 19),
            buyButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -19),
            buyButton.heightAnchor.constraint(equalToConstant: 48),
            //aboutItem
            abouItem.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 28),
            abouItem.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            abouItem.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30),
            //toBuyListButton
            toBuyList.topAnchor.constraint(equalTo: mainView.topAnchor, constant: hasNoth ? 4 : statusBarHeight + 8),
            toBuyList.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            toBuyList.widthAnchor.constraint(equalToConstant: 28),
            toBuyList.heightAnchor.constraint(equalToConstant: 28),
            //backButton
            backButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: hasNoth ? 4 : statusBarHeight + 8),
            backButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28),
            
        ])
    }
    
    private func imagesLoad() {
        images.contentSize = CGSize(width: CGFloat(imageUrl.count) * images.bounds.width, height: images.bounds.height)
        images.isUserInteractionEnabled = true
        images.isPagingEnabled = true
        pageControl.numberOfPages = imageUrl.count
        pageControl.addTarget(self, action: #selector(pageChange), for: .valueChanged)
        var x:CGFloat = 0
        for elem in imageUrl {
            let imageView = ImageShopItemCell()
            let indicator = UIActivityIndicatorView()
            images.addSubview(indicator)
            indicator.center = CGPoint(x: x + images.bounds.width / 2, y: images.bounds.height / 2)
            indicator.startAnimating()
            images.addSubview(imageView)
            imageView.frame = CGRect(x: x, y: 0, width: images.bounds.width, height: images.bounds.height)
            loadPicture(url: elem, complite: {
                image in
                imageView.picView.image = image
                imageView.clipsToBounds = true
                indicator.removeFromSuperview()
            })
            x += images.bounds.width
        }
    }
    
    private func loadPicture(url: String, complite: @escaping (_ image: UIImage) -> Void) {
        //try load from realm
        if let oldImage = PersistanceData.shared.loadImage(url: url) {
            complite(oldImage)
        }
        //try load from network
        DataLoader.shared.getImageFromWeb(DataNow.shared.url + url, closure: {
            image in
            if image != nil {
                complite(image!)
                PersistanceData.shared.saveImage(image: image!, url: url)
            }else{
                complite(UIImage(named: "NoImg")!)
                PersistanceData.shared.saveFailData(url: url)
            }
        })
    }
    
    private func backButtonInit() {
        mainView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "BackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(goToBack), for: .touchUpInside)
    }
    
    
    private func toBouyListButtonInit() {
        mainView.addSubview(toBuyList)
        toBuyList.translatesAutoresizingMaskIntoConstraints = false
        toBuyList.addTarget(self, action: #selector(goToBuyList), for: .touchUpInside)
        toBuyList.setImage(UIImage(named: "BuyButton"), for: .normal)
    }
    
    private func abouItemInit() {
        mainView.addSubview(abouItem)
        abouItem.translatesAutoresizingMaskIntoConstraints = false
        abouItem.numberOfLines = 0
        abouItem.text = descriptionData
        abouItem.font = UIFont(name: "Roboto-Regular", size: 16)
    }
    
    private func buttonInit() {
        mainView.addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        buyButton.layer.cornerRadius = 48 / 4
        buyButton.setTitle("Добавить в корзину", for: .normal)
    }
    
    private func priceInit() {
        mainView.addSubview(priceStack)
        priceStack.translatesAutoresizingMaskIntoConstraints = false
        priceStack.addArrangedSubview(priceLabel)
        priceStack.addArrangedSubview(price)
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.text = "Стоимость:"
        price.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        price.text = priceData + " ₽"
        price.textColor = UIColor(displayP3Red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        if intefaceIsDark {
            price.textColor = UIColor.white.withAlphaComponent(0.7)
        }
        priceStack.axis = .horizontal
        priceStack.alignment = .fill
        priceStack.distribution = .equalSpacing
    }
    
    private func lineInit() {
        mainView.addSubview(lineGray)
        lineGray.translatesAutoresizingMaskIntoConstraints = false
        lineGray.backgroundColor = .gray
    }
    
    private func nameInit() {
        mainView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = nameData
        name.font = UIFont.systemFont(ofSize: 36)
        name.numberOfLines = 2
        name.sizeToFit()
        name.textAlignment = .center
    }
    
    private func mainScrollViewInit() {
        self.view.addSubview(mainScrollView)
        mainScrollView.addSubview(mainView)
        mainScrollView.delegate = self
        mainScrollView.isUserInteractionEnabled = true
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.contentSize = UIScreen.main.bounds.size
        mainView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mainScrollView.contentSize)
        mainScrollView.backgroundColor = intefaceIsDark ? .black : .white
    }
    
    private func imagesInit() {
        mainView.addSubview(images)
        images.delegate = self
        pageControlInit()
        pageControl.currentPage = 0
        images.backgroundColor = .gray
        images.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func pageControlInit() {
        mainView.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(displayP3Red: 0/255, green: 200/255, blue: 83/255, alpha: 1)
    }
    
    
    @objc private func goToBuyList() {
        
    }
    
    @objc private func goToBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func pageChange() {
        images.contentOffset.x = images.frame.width * CGFloat(pageControl.currentPage)
        
    }
    
    

}

extension CartItemController: UIScrollViewDelegate {
    
    private func updateScrollViewHeight() {
        var contentRect = CGRect.zero
        for view in self.mainView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.contentSize.width, height: contentRect.size.height + 50)
        self.mainView.frame.size = CGSize(width: self.mainScrollView.contentSize.width, height: contentRect.size.height + 50)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if images.contentSize.width > images.frame.width {
            pageControl.currentPage = Int(round(images.contentOffset.x / images.frame.width))
        }
    }
    
}
