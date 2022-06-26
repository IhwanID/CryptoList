//
//  DummyViewController.swift
//  CryptoList
//
//  Created by Ihwan on 26/06/22.
//

import UIKit


class DummyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: label.topAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
