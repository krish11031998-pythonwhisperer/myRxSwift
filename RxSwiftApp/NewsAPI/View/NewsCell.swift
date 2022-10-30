//
//  NewsCell.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 26/10/2022.
//

import Foundation
import UIKit

class NewsCell: ConfigurableCell {
    
    private lazy var newsImg: UIImageView = {
       let imgView = UIImageView()
        imgView.backgroundColor = .black
        imgView.clippedCornerRadius = 12
        imgView.contentMode = .scaleAspectFill
        imgView.setFrame(.init(squared: 84))
        return imgView
    }()
    
    private lazy var newsHeader: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var newsDescription: UILabel  = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let stack = UIStackView.VStack(subViews:[newsHeader, newsDescription], spacing: 12)
        
        let mainStack = UIStackView.HStack(subViews: [stack, newsImg], spacing: 10, alignment: .top)
        
        let card = mainStack.embedIntoCard(inset: .init(by: 12.5), cornerRadius: 12, clipped: false)
        card.backgroundColor = .surfaceBackground
        card.addShadow()
        contentView.addSubview(card)
        contentView.backgroundColor = .surfaceBackground
        contentView.setFittingConstraints(childView: card, insets: .init(vertical: 5, horizontal: 15))
        card.setHeight(height: 125)
    }

    override func prepareForReuse() {
        newsImg.image = nil
    }
    
    func configure(with model: NewsModel) {
        model.title?.bold(size: 16).render(target: newsHeader)
        model.description?.regular(size: 12).render(target: newsDescription)
        if let imgURL = model.urlToImage {
            UIImage.loadImage(url: imgURL, for: newsImg, at: \.image)
        }
    }
    
}


