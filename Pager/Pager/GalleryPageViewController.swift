//
//  GalleryPageViewController.swift
//  Pager
//
//  Created by Test on 01/03/2024.
//

import UIKit

enum GalleryDirection {
    case before, after, around
    
    var navigation: UIPageViewController.NavigationDirection {
        switch self {
        case .before:
            return .reverse
        case .after:
            return .forward
        case .around:
            return .forward
        }
    }
}

class GalleryPageViewController: UIPageViewController {
    var currentController: PreviewControllerForPager? {
        return viewControllers?.first as? PreviewControllerForPager
    }
    var galleryView: GalleryCollectionView = GalleryCollectionView()
    
    var items: [ExtendedPreviewItem] = []
    var cacheControllers: [ExtendedPreviewItem : PreviewControllerForPager] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureView()
        
        dataSource = self
        delegate = self
        galleryView.delegate = self
        
        guard let model = items.first else { return }
        setViewControllers([createController(for: model)],
                           direction: .forward,
                           animated: false)
        
    }
    
    func loadData() {
        items.append(contentsOf: Documents.items)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let model = items.first else { return }
        goTo(pageAt: model)
        galleryView.update(model: items, focusedItem: model)
    }
    
    private func configureView() {
        view.addSubview(galleryView)
        
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        
        galleryView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        galleryView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        galleryView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        galleryView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func goTo(pageAt item: ExtendedPreviewItem) {
        guard   let currentItem = currentController?.model,
                let currentIndex = items.firstIndex(of: currentItem),
                let targetIndex = items.firstIndex(of: item)
        else { return }
        let direction = direction(forCurrent: currentIndex, nextItemIndex: targetIndex)
        
        let controller = createController(for: item)
        
        setViewControllers([controller], direction: direction.navigation, animated: true)
    }
    
    func direction(forCurrent itemIndex: Int, nextItemIndex: Int) -> GalleryDirection {
        if itemIndex > nextItemIndex {
            return .before
        } else if itemIndex < nextItemIndex {
            return .after
        }
        return .around
    }
    
    func item(direction: GalleryDirection, forCurrent item: ExtendedPreviewItem) -> ExtendedPreviewItem? {
        switch direction {
        case .before:
            if items.count > 0,
               let currentIndex = items.firstIndex(of: item) {
                if currentIndex - 1 < 0 {
                    return items.last
                }
                return items[currentIndex - 1]
            }
        case .after:
            if items.count > 0,
               let currentIndex = items.firstIndex(of: item)
            {
                if currentIndex + 1 < items.count {
                    return items[currentIndex + 1]
                }
                return items.first
            }
        case .around:
            return item
        }
        
        return nil
    }
    
    func createController(for model: ExtendedPreviewItem) -> PreviewControllerForPager {
        var controller = cacheControllers[model]
        
        if controller == nil {
            controller = PreviewControllerForPager(model)
            cacheControllers[model] = controller
        }
        
        return controller!
    }
}


extension GalleryPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard   let viewController = viewController as? PreviewControllerForPager,
                let nextColor = item(direction: .before, forCurrent: viewController.model)
        else { return nil }

        return createController(for: nextColor)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard   let viewController = viewController as? PreviewControllerForPager,
                let nextColor = item(direction: .after, forCurrent: viewController.model)
        else { return nil }

        return createController(for: nextColor)
    }
}

extension GalleryPageViewController: GalleryCollectionViewDelegate {
    func galleryCollectionView(_ view: GalleryCollectionView, goTo item: ExtendedPreviewItem) {
        goTo(pageAt: item)
    }
}

