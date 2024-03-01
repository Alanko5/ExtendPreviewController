// ExtendedPreviewItem.swift
//
// ExtendedPreviewItem for Silentel
//
// @author Test
//
// Copyright © 2024 Ardaco a.s. All rights reserved.

import UIKit
import QuickLook
import QuickLookThumbnailing

enum ExtendedPreviewItemState {
    case ready
    case generating
    case needGenerate
    case error(_ error: Error)
}

final class ExtendedPreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String?
    var attachmentID: Int
    var isSelectedItem: Bool
    
    var onStateUpdate: ((ExtendedPreviewItemState) -> Void )?
    var onImageUpdate: ((UIImage?) -> Void )?
    
    private(set) var state: ExtendedPreviewItemState = .needGenerate {
        didSet {
            onStateUpdate?(state)
        }
    }
    private(set) var image: UIImage? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.onImageUpdate?(self.image)
            }
        }
    }
    
    init(itemURL: URL, title: String, attID: Int, isFocused: Bool) {
        self.previewItemURL = itemURL
        self.previewItemTitle = title
        self.attachmentID = attID
        self.isSelectedItem = isFocused
        super.init()
        startGenerate()
    }
}

extension ExtendedPreviewItem {
    private func startGenerate() {
        guard let previewItemURL else { return }
        state = .generating
        let requ = QLThumbnailGenerator.Request(fileAt: previewItemURL,
                                                size: .init(width: 450, height: 800),
                                                scale: UIScreen.main.scale,
                                                representationTypes: .all)
        QLThumbnailGenerator.shared.generateBestRepresentation(for: requ) { [weak self] thumbnail, error in
            guard let self else { return }
            if let error {
                self.state = .error(error)
                return
            }
            guard let thumbnail else { return }
            self.image = UIImage(cgImage: thumbnail.cgImage,
                                 scale: UIScreen.main.scale,
                                 orientation: .up)
            self.state = .ready
        }
    }
}
