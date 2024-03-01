//
//  CalleryCell.swift
//  Pager
//
//  Created by Test on 01/03/2024.
//

import UIKit

protocol GalleryItemCellViewDelegate: AnyObject {
    func didTapGalleryItemCellView(_ galleryItemCellView: GalleryItemCellView)
}
final class GalleryItemCellView: UIView {
    
    var isCellFocused: Bool = false {
        didSet {
            if isCellFocused {
                layer.cornerRadius = 5
            } else {
                layer.cornerRadius = 0
            }
        }
    }
    
    weak var delegate: GalleryItemCellViewDelegate?
    private(set) var model: ExtendedPreviewItem
    private var imageView = UIImageView()
    
    init(model: ExtendedPreviewItem) {
        self.model = model
        super.init(frame: .zero)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        addGestureRecognizer(tapGesture)
        
        self.model.onImageUpdate = { [unowned self] image in
            self.imageView.image = image
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc
    private func didTap(sender: UITapGestureRecognizer) {
        delegate?.didTapGalleryItemCellView(self)
    }
    
    static func buildViews(for items:[ExtendedPreviewItem],
                           focusedItem: ExtendedPreviewItem,
                           size: CGFloat,
                           delegate: GalleryItemCellViewDelegate) -> [GalleryItemCellView]
    {
        var views: [GalleryItemCellView] = []
        for item in items {
            let cellView = GalleryItemCellView(model: item)
            cellView.delegate = delegate
            cellView.backgroundColor = .blue
            cellView.isCellFocused = item == focusedItem
            cellView.addSubview(cellView.imageView)
            cellView.imageView.image = item.image
            cellView.model = item
            
            cellView.imageView.translatesAutoresizingMaskIntoConstraints = false
            
            cellView.imageView.topAnchor.constraint(equalTo: cellView.topAnchor).isActive = true
            cellView.imageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor).isActive = true
            cellView.imageView.rightAnchor.constraint(equalTo: cellView.rightAnchor).isActive = true
            cellView.imageView.leftAnchor.constraint(equalTo: cellView.leftAnchor).isActive = true
            cellView.imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            cellView.imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            cellView.clipsToBounds = true
            views.append(cellView)
        }
        
        return views
    }
}

