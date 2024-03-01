//
//  PreviewController.swift
//  Pager
//
//  Created by Test on 01/03/2024.
//

import UIKit
import QuickLook

extension UINavigationBar {
    static var isHiddenNotify: Notification.Name {
        Notification.Name("UINavigationBar.isHidden")
    }
    open override var isHidden: Bool {
        didSet {
            NotificationCenter.default.post(name: UINavigationBar.isHiddenNotify,
                                            object: nil,
                                            userInfo: ["UINavigationBar.isHidden":true])
        }
    }
}

final class PreviewController: QLPreviewController {
    private(set) var items: [ExtendedPreviewItem] = []
    private let galleryView = GalleryCollectionView(frame: .zero)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        loadItems()
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadItems()
        delegate = self
        dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(navbarnotify(_:)),
                                               name: UINavigationBar.isHiddenNotify,
                                               object: nil)
        
        configureViews()
        galleryView.delegate = self
        updateCurrentPreviewItem()
    }
    
    override var currentPreviewItemIndex: Int {
        didSet {
            // not working
            guard currentPreviewItemIndex != NSNotFound else { return }
            galleryView.update(model: items, focusedIndex: currentPreviewItemIndex)
        }
    }
    
    private func updateCurrentPreviewItem() {
        for  (index, item) in items.enumerated() {
            if item.isSelectedItem {
                currentPreviewItemIndex = index
            }
        }
    }
    
    private func loadItems() {
        items.append(contentsOf: Documents.items)
        
        galleryView.update(model: items, focusedIndex: items.firstIndex(where: { $0.isSelectedItem }) ?? 0)
    }
    
    private func configureViews() {
        // not showing
        view.addSubview(galleryView)
        
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        
        galleryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        galleryView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        galleryView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        galleryView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        galleryView.isHidden = false
    }
    
    @objc
    private func navbarnotify(_ notification: Notification) {
        guard let isHidden = notification.userInfo?["UINavigationBar.isHidden"] as? Bool else { return }
        galleryView.isHidden = isHidden
    }
}

extension PreviewController: GalleryCollectionViewDelegate {
    func galleryCollectionView(_ view: GalleryCollectionView, goTo item: ExtendedPreviewItem) {
        guard let index = items.firstIndex(where: { $0 == item }) else { return }
        items.forEach({ $0.isSelectedItem = $0 == item })
        currentPreviewItemIndex = index
        refreshCurrentPreviewItem()
    }
}

extension PreviewController: QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return items.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        return items[index]
    }
}
