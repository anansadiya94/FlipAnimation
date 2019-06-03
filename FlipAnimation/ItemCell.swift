//
//  ItemTableViewCell.swift
//  FlipAnimation
//
//  Created by Anan Sadiya on 03/06/2019.
//  Copyright © 2019 Anan Sadiya. All rights reserved.
//

import UIKit

protocol ItemTableViewCellDelegate: class {
    func changeItemStatus(displayItem: DisplayItem)
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var flipView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let backImageView: UIImageView! = UIImageView(image: UIImage(named: "back"))
    private var frontImageView = UIImageView()
    private var spinTimeInterval = 0.5
    weak var itemTableViewCellDelegate: ItemTableViewCellDelegate?
    var displayItem: DisplayItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(displayItem: DisplayItem, itemTableViewCellDelegate: ItemTableViewCellDelegate) {
        self.itemTableViewCellDelegate = itemTableViewCellDelegate
        self.displayItem = displayItem
        self.titleLabel.text = displayItem.title
        self.frontImageView.image = UIImage(named: displayItem.image)
        changeCellBackgroundColor(displayItem)
        configureFlipView()
    }
    
    private func changeCellBackgroundColor(_ displayItem: DisplayItem) {
        self.backgroundColor = displayItem.isItemSelected ? UIColor.green.withAlphaComponent(0.25) : .white
    }
    
    private func configureFlipView() {
        backImageView.frame = CGRect(x: 0, y: 0, width: flipView.frame.width, height: flipView.frame.height)
        backImageView.layer.cornerRadius = backImageView.frame.size.width / 2
        backImageView.clipsToBounds = true
        backImageView.contentMode = .scaleToFill
        
        frontImageView.frame = CGRect(x: 0, y: 0, width: flipView.frame.width, height: flipView.frame.height)
        frontImageView.layer.cornerRadius = frontImageView.frame.size.width / 2
        frontImageView.clipsToBounds = true
        frontImageView.contentMode = .scaleToFill
        
        frontImageView.isHidden = displayItem!.isItemSelected
        backImageView.isHidden = !displayItem!.isItemSelected
        
        flipView.addSubview(backImageView)
        flipView.addSubview(frontImageView)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flipTapped))
        flipView.addGestureRecognizer(singleTap)
    }
    
    @objc func flipTapped() {
        flip(displayItem: displayItem!)
        changeItemStatus(displayItem: displayItem!)
    }
    
    func flip(displayItem: DisplayItem) {
        var displayFlipItem = displayItem
        frontImageView.isHidden = !displayFlipItem.isItemSelected
        backImageView.isHidden = displayFlipItem.isItemSelected
        
        UIView.transition(from: displayFlipItem.isItemSelected ? frontImageView : backImageView,
                          to: displayFlipItem.isItemSelected ? frontImageView : backImageView,
                          duration: spinTimeInterval,
                          options: [.transitionFlipFromLeft, .showHideTransitionViews])
        
        displayFlipItem.isItemSelected = !displayFlipItem.isItemSelected
        self.displayItem = displayFlipItem
        changeCellBackgroundColor(displayFlipItem)
    }
    
    func changeItemStatus(displayItem: DisplayItem) {
        itemTableViewCellDelegate?.changeItemStatus(displayItem: displayItem)
    }
}
