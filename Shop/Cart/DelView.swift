//
//  delView.swift
//  Shop
//
//  Created by Mahutin Aleksei on 06/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

protocol DelViewDelegate {
    func pressYes()
    func pressNo()
}

class DelView: UIView, InterfaceIsDark {
    var intefaceIsDark: Bool { return traitCollection.userInterfaceStyle == .dark }
    
    
    private let label = UILabel()
    private let yes = UIButton()
    private let no = UIButton()
    var delegate: DelViewDelegate?
    
    
    override func didMoveToSuperview() {
        buttonInit()
        labelInit()
        constraintsInit()
    }
    
    func constraintsInit() {
        NSLayoutConstraint.activate([
            //label
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 38),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            //yes
            yes.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 33),
            yes.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 29),
            yes.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -29),
            //no
            no.topAnchor.constraint(equalTo: yes.bottomAnchor, constant: 12),
            no.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 29),
            no.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -29),
            no.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -38),
        ])
    }
    
    private func buttonInit() {
        for elem in [yes,no] {
            self.addSubview(elem)
            elem.translatesAutoresizingMaskIntoConstraints = false
            elem.layer.cornerRadius = 4
        }
        yes.addTarget(self, action: #selector(pressYes), for: .touchUpInside)
        no.addTarget(self, action: #selector(pressNo), for: .touchUpInside)
        yes.setTitle("ДА", for: .normal)
        no.setTitle("НЕТ", for: .normal)
        yes.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        yes.titleLabel?.textColor = .white
        no.layer.borderWidth = 1
        let color = intefaceIsDark ? UIColor.white : .black
        no.layer.borderColor = color.cgColor
        no.titleLabel?.textColor = color
    }
    
    private func labelInit() {
        label.numberOfLines = 2
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
    }

    @objc private func pressYes() {
        delegate?.pressYes()
    }
    
    @objc private func pressNo() {
        delegate?.pressNo()
    }
    
    func style(deleteAll: Bool) {
        if deleteAll {
            label.text = "Удалить все товары из корзины?"
        }else{
            label.text = "Удалить товар из корзины?"
            
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
