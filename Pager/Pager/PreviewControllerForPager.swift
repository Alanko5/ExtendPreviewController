//
//  PreviewControllerForPager.swift
//  Pager
//
//  Created by Test on 01/03/2024.
//

import Foundation
import QuickLook

class PreviewControllerForPager: QLPreviewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    let ignoreView = UIView()
    
    private(set) var model: ExtendedPreviewItem
    init(_ model: ExtendedPreviewItem) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(ignoreView)
        ignoreView.translatesAutoresizingMaskIntoConstraints = false
        ignoreView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        ignoreView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        ignoreView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        ignoreView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        ignoreView.backgroundColor = .black.withAlphaComponent(0.01)
        
        addGestures()
    }
    
    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        ignoreView.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
        for subview in view.subviews {
            subview.addGestureRecognizer(tap)
        }
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        if ignoreView.isHidden {
            ignoreView.isHidden = false
        } else {
            ignoreView.isHidden = true
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        model
    }
    
    func previewController(_ controller: QLPreviewController,
                           editingModeFor previewItem: any QLPreviewItem) -> QLPreviewItemEditingMode {
        .disabled
    }
}
