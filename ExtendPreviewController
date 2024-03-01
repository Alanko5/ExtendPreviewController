import UIKit
import QuickLook

class PreviewController: QLPreviewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
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

class ViewController: UIPageViewController {
    var currentController: PreviewController? {
        return viewControllers?.first as? PreviewController
    }
    var galleryView: GalleryCollectionView = GalleryCollectionView()
    
    var colors: [ExtendedPreviewItem] = []
    var cacheControllers: [ExtendedPreviewItem : PreviewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureView()
        
        dataSource = self
        delegate = self
        galleryView.delegate = self
        
        guard let model = colors.first else { return }
        setViewControllers([createController(for: model)],
                           direction: .forward,
                           animated: false)
        
    }
    
    func loadData() {
        if let docx = Bundle.main.path(forResource: "text", ofType: "txt") {
            colors.append(ExtendedPreviewItem(itemURL: URL(fileURLWithPath: docx), title: "message", attID: 0))
        }
        if let docx = Bundle.main.path(forResource: "document", ofType: "docx") {
            colors.append(ExtendedPreviewItem(itemURL: URL(fileURLWithPath: docx), title: "PonukaHviezdoslavov", attID: 1))
        }
        if let docx = Bundle.main.path(forResource: "image", ofType: "jpg") {
            colors.append(ExtendedPreviewItem(itemURL: URL(fileURLWithPath: docx), title: "vianoce", attID: 2))
        }
        
        if let docx = Bundle.main.path(forResource: "sheet", ofType: "xlsx") {
            colors.append(ExtendedPreviewItem(itemURL: URL(fileURLWithPath: docx), title: "Dokument", attID: 4))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let model = colors.first else { return }
        goTo(pageAt: model)
        galleryView.update(model: colors, focusedItem: model)
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
                let currentIndex = colors.firstIndex(of: currentItem),
                let targetIndex = colors.firstIndex(of: item)
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
            if colors.count > 0,
               let currentIndex = colors.firstIndex(of: item) {
                if currentIndex - 1 < 0 {
                    return colors.last
                }
                return colors[currentIndex - 1]
            }
        case .after:
            if colors.count > 0,
               let currentIndex = colors.firstIndex(of: item)
            {
                if currentIndex + 1 < colors.count {
                    return colors[currentIndex + 1]
                }
                return colors.first
            }
        case .around:
            return item
        }
        
        return nil
    }
    
    func createController(for model: ExtendedPreviewItem) -> PreviewController {
        var controller = cacheControllers[model]
        
        if controller == nil {
            controller = PreviewController(model)
            cacheControllers[model] = controller
        }
        
        return controller!
    }
}


extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, 
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard   let viewController = viewController as? PreviewController,
                let nextColor = item(direction: .before, forCurrent: viewController.model)
        else { return nil }

        return createController(for: nextColor)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, 
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard   let viewController = viewController as? PreviewController,
                let nextColor = item(direction: .after, forCurrent: viewController.model)
        else { return nil }

        return createController(for: nextColor)
    }
}

extension ViewController: GalleryCollectionViewDelegate {
    func galleryCollectionView(_ view: GalleryCollectionView, goTo item: ExtendedPreviewItem) {
        goTo(pageAt: item)
    }
}

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


// MARK: -- item cells
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

extension UIView {
    func autoPinEdgesToSuperViewEdges() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}
