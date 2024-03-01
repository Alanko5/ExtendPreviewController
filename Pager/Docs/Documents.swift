//
//  Documents.swift
//  Pager
//
//  Created by Test on 01/03/2024.
//

import Foundation

final class Documents {
    static var items: [ExtendedPreviewItem] {
        var items: [ExtendedPreviewItem] = []
        if let docx = Bundle.main.path(forResource: "LoremIpsum", ofType: "txt") {
            items.append(ExtendedPreviewItem(itemURL: URL(fileURLWithPath: docx), 
                                             title: "LoremIpsum Text",
                                             attID: 0, 
                                             isFocused: false))
        }
        if let docx = Bundle.main.path(forResource: "LoremIpsum", ofType: "docx") {
            items.append(ExtendedPreviewItem(itemURL: URL(fileURLWithPath: docx),
                                             title: "LoremIpsum word", 
                                             attID: 1,
                                             isFocused: false))
        }
        if let docx = Bundle.main.path(forResource: "LoremIpsum", ofType: "jpg") {
            items.append(ExtendedPreviewItem(itemURL: URL(fileURLWithPath: docx), 
                                             title: "LoremIpsum image",
                                             attID: 2,
                                             isFocused: true))
        }
        
        if let docx = Bundle.main.path(forResource: "LoremIpsum", ofType: "xlsx") {
            items.append(ExtendedPreviewItem(itemURL: URL(fileURLWithPath: docx), 
                                             title: "LoremIpsum xlsx",
                                             attID: 4,
                                             isFocused: false))
        }
        return items
    }
}
