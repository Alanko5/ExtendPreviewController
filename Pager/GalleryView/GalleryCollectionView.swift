//
//  GalleryCollectionView.swift
//  Pager
//
//  Created by Test on 01/03/2024.
//

import Foundation
import QuickLook

protocol GalleryCollectionViewDelegate: AnyObject {
    func galleryCollectionView(_ view: GalleryCollectionView, goTo item:ExtendedPreviewItem)
}

// MARK: - collection
final class GalleryCollectionView: UIView {
    weak var delegate: GalleryCollectionViewDelegate?
    
    private let galleryView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.clipsToBounds = false
        scrollView.layoutMargins = .zero
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private var lastKnownScrollViewWidth: CGFloat = 0
    private let itemSize: CGFloat = 40
    private var cellViews: [GalleryItemCellView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var isScrollEnabled: Bool {
        get { galleryView.isScrollEnabled }
        set { galleryView.isScrollEnabled = newValue }
    }
    
    func update(model items:[ExtendedPreviewItem], focusedItem: ExtendedPreviewItem) {
        cellViews = GalleryItemCellView.buildViews(for: items,
                                                   focusedItem: focusedItem,
                                                   size: itemSize,
                                                   delegate: self)
        installNewStackView(arrangedSubviews: cellViews)
        
        UIView.performWithoutAnimation {
            self.layoutIfNeeded()
        }
        
        scrollToFocusedCell(animated: false)
    }
    
    func update(model items:[ExtendedPreviewItem], focusedIndex: Int) {
        guard items.count > focusedIndex else { return }
        update(model: items, focusedItem: items[focusedIndex])
    }
    
    private func configureView() {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurBackgroundView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurBackgroundView)
        blurBackgroundView.autoPinEdgesToSuperViewEdges()
        
        addSubview(galleryView)
        
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        
        galleryView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        galleryView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        galleryView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        galleryView.heightAnchor.constraint(equalToConstant: itemSize + 1).isActive = true
        
        galleryView.addSubview(stackView)
        
        stackView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: itemSize))
        
    }
    
    private func updateScrollViewContentInsetsIfNecessary() {
        guard stackView.frame.width > 0, galleryView.frame.width > 0  else { return }

        let scrollViewWidth = galleryView.frame.width
        guard scrollViewWidth != lastKnownScrollViewWidth else { return }
        
        let horizontalContentInset = 0.5 * (scrollViewWidth - itemSize)
        galleryView.contentInset.left = horizontalContentInset
        galleryView.contentInset.right = horizontalContentInset
        
        lastKnownScrollViewWidth = scrollViewWidth
    }
    
    private func scrollToFocusedCell(animated: Bool) {
        guard let focusedCell = cellViews.first(where: { $0.isCellFocused }) else { return }
        let cellFrame = focusedCell.convert(focusedCell.bounds, to: galleryView)
        galleryView.scrollRectToVisible(cellFrame, animated: animated)
    }
}

extension GalleryCollectionView: GalleryItemCellViewDelegate {
    func didTapGalleryItemCellView(_ galleryItemCellView: GalleryItemCellView) {
        delegate?.galleryCollectionView(self, goTo: galleryItemCellView.model)
    }
}

// MARK: - stack view
extension GalleryCollectionView {
    private func installNewStackView(arrangedSubviews: [UIView]) {
        var newFrame = CGRect(origin: .zero, size: CGSize(width: .zero, height: itemSize))
        
        if arrangedSubviews.count > 0 {
            let itemsWidth = itemSize * CGFloat(arrangedSubviews.count)
            let spacingWidth = stackView.spacing * CGFloat(arrangedSubviews.count - 1)
            
            newFrame.size.width =  itemsWidth + spacingWidth
        }
        
        for arrangedSubview in arrangedSubviews {
            stackView.addArrangedSubview(arrangedSubview)
        }
        
        stackView.frame = newFrame
        galleryView.contentSize = newFrame.size
        updateScrollViewContentInsetsIfNecessary()
    }
}
