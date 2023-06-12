//
//  SearchTextCollectionViewCell.swift
//  Pexels
//
//  Created by Firuza Raiymkul on 09.06.2023.
//

import UIKit

class SearchTextCollectionViewCell: UICollectionViewCell {
    
    static let id: String = "SearchTextCollectionViewCell"
    
    let view                = UIView()
    let cardView            = UIView()
    let horizontalStackView = UIStackView()
    let imageView           = UIImageView()
    let historyLabel        = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardView.layer.borderWidth  = 1
        cardView.layer.borderColor  = UIColor.lightGray.cgColor
        cardView.layer.cornerRadius = 10

        setupAllTheCellsView()
        
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(view)
//        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.heightAnchor.constraint(equalToConstant: 60),
            view.widthAnchor.constraint(equalToConstant: 100)

        
        ])

    }
    
    func setupSubView() {
        view.addSubview(cardView)
        
        
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.topAnchor.constraint(equalTo: view.topAnchor)
            
        ])
    }
    
    func setupHorizontalStackView() {
        
        cardView.addSubview(horizontalStackView)
        horizontalStackView.spacing = 8
//        horizontalStackView.distribution = .fillEqually
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            horizontalStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            horizontalStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            horizontalStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 8)
        
        ])
    }
    
    func setupImageView() {
        horizontalStackView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image       = UIImage(systemName: "clock")
        imageView.tintColor   = .lightGray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
          
            imageView.heightAnchor.constraint(equalToConstant: 24)
            
            
        ])
        
        let aspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0)
        
        aspectRatioConstraint.isActive = true
        

        
    }
    
    func setupLabel() {
        
        horizontalStackView.addSubview(historyLabel)
    
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            historyLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8)
        
        ])
        
        historyLabel.textColor = .systemGray
        historyLabel.font      = historyLabel.font.withSize(15)
        historyLabel.text = "Label"
        
    }
    
    // здесь содержатся все вызовы функций, которые рисуют интерфейс
    func setupAllTheCellsView() {
        setupView()
        setupSubView()
        setupHorizontalStackView()
        setupImageView()
        setupLabel()
    }
}
