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
    
    var text: String = "Aspen Gold"
    
    private let mainScrollView = UIScrollView()
    private let mainView = UIView()
    private let images = UIScrollView()
    private let name = UILabel()
    private let abouItem = UILabel()
    private let buyButton = UIButton()
    private let backButton = UIButton()
    private let toBuyList = UIButton()
    private let pageControl = UIPageControl()
    private let lineGray = UIView()
    
    private let priceStack = UIStackView()
    private let price = UILabel()
    private let priceLabel = UILabel()

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
        constraintInit()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateScrollViewHeight()
    }
    
    private func constraintInit() {
        NSLayoutConstraint.activate([
            //mainScrolView
            mainScrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -(self.navigationController?.navigationBar.frame.height ?? 0)),
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
            name.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 16),
            name.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
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
            
        ])
    }
    
    private func abouItemInit() {
        mainView.addSubview(abouItem)
        abouItem.translatesAutoresizingMaskIntoConstraints = false
        abouItem.numberOfLines = 0
        abouItem.text = "test description"
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
        price.text = "1000"
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
        name.text = text
        name.font = UIFont.systemFont(ofSize: 36)
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
        images.backgroundColor = .gray
        images.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func pageControlInit() {
        mainView.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = UIColor(displayP3Red: 0/255, green: 200/255, blue: 83/255, alpha: 1)
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
    
}
