//
//  ExtendedPreviewController.swift
//  Pager
//
//  Created by Test on 04/03/2024.
//

import UIKit
import QuickLook

final class QLPreviewControllerObserved: QLPreviewController {
    private var observation: [NSKeyValueObservation] = []
    var onCurrentPreviewItemIndexChange: ((_ oldIndex: Int?, _ newIndex: Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observation.append(observe(\.currentPreviewItemIndex,
                                    options: [.new] )
              { [weak self] object, change in
                  self?.onCurrentPreviewItemIndexChange?(change.oldValue, change.newValue)
              }
        )
    }
    
    func focusTo(index: Int) {
        currentPreviewItemIndex = index
        refreshCurrentPreviewItem()
    }
    
    deinit {
        observation.forEach({ $0.invalidate() })
        observation.removeAll()
    }
}

final class ExtendedPreviewController: UIViewController {
    private(set) var qlPreviewController: QLPreviewControllerObserved
    private(set) var items: [ExtendedPreviewItem] = Documents.items
    
    private let qlPreviewView = UIView()
    private let galleryView = GalleryCollectionView(frame: .zero)
    
    init() {
        qlPreviewController = QLPreviewControllerObserved()
        super.init(nibName: nil, bundle: nil)
        configureGallery()
        configureSubViews()
        configureQLPrevieController()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        qlPreviewController.view.removeFromSuperview()
        qlPreviewController.removeFromParent()
    }
}

// MARK: - QLPreview Delegate DataSource
extension ExtendedPreviewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        items.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        items[index]
    }
    
    private func onCurrentItemUpdate(_ oldIndex: Int?, _ newIndex: Int?) {
        guard let newIndex else { return }
        galleryView.update(model: items, focusedIndex: newIndex)
    }
}

// MARK: - gallery delegate
extension ExtendedPreviewController: GalleryCollectionViewDelegate {
    func galleryCollectionView(_ view: GalleryCollectionView, goTo item: ExtendedPreviewItem) {
        guard let selected = items.firstIndex(where: { $0 == item }) else { return }
        qlPreviewController.focusTo(index: selected)
        galleryView.update(model: items, focusedIndex: selected)
    }
}

// MARK: - handle tap
extension ExtendedPreviewController
{
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handle(_:)))
        qlPreviewView.addGestureRecognizer(tap)
    }
    
    @objc
    private func handle(_ sender: UITapGestureRecognizer?) {
        // not working
        print("tap")
    }
}

// MARK: - adding views
extension ExtendedPreviewController
{
    private func configureQLPrevieController() {
        qlPreviewController.currentPreviewItemIndex = 0
        
        qlPreviewController.onCurrentPreviewItemIndexChange = { [weak self] (oldIndex,newIndex) in
            self?.onCurrentItemUpdate(oldIndex, newIndex)
        }
        
        qlPreviewController.delegate = self
        qlPreviewController.dataSource = self
        qlPreviewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(qlPreviewController)
        qlPreviewView.addSubview(qlPreviewController.view)
        
        qlPreviewController.view.topAnchor.constraint(equalTo: qlPreviewView.topAnchor).isActive = true
        qlPreviewController.view.rightAnchor.constraint(equalTo: qlPreviewView.rightAnchor).isActive = true
        qlPreviewController.view.leftAnchor.constraint(equalTo: qlPreviewView.leftAnchor).isActive = true
        qlPreviewController.view.bottomAnchor.constraint(equalTo: qlPreviewView.bottomAnchor).isActive = true
    }
    
    private func configureGallery() {
        galleryView.delegate = self
        galleryView.update(model: items, focusedItem: items.first)
    }
    
    private func configureSubViews() {
        view.addSubview(qlPreviewView)
        view.addSubview(galleryView)
        
        qlPreviewView.translatesAutoresizingMaskIntoConstraints = false
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        
        qlPreviewView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        qlPreviewView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        qlPreviewView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        qlPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        galleryView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        galleryView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        galleryView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        galleryView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
