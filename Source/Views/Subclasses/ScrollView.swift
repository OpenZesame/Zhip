//
//  ScrollViewOwner.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

private typealias € = L10n.View.PullToRefreshControl

// MARK: - ScrollView
class ScrollView: UIScrollView {

    // MARK: Initialization
    init() {
        super.init(frame: .zero)
        privateSetup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    var contentView: UIView!

    // MARK: Overrideable
    func setup() { /* subclass me */ }

    private var refreshControlCustomView: RefreshControlCustomView?

    func setRefreshControlTitle(_ title: String) {
        guard let refreshControlCustomView = refreshControlCustomView else {
            return
        }
        refreshControlCustomView.setTitle(title)
    }
}

final class RefreshControlCustomView: UIView {
    private lazy var spinner = SpinnerView()
    private lazy var label = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [spinner, label])

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

extension RefreshControlCustomView {
    func setTitle(_ title: String) {
        label.text = title
    }
}

private extension RefreshControlCustomView {
    func setup() {
        contentMode = .scaleToFill
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        label.withStyle(.init(textAlignment: .center, textColor: .white, font: .title))
        stackView.withStyle(.vertical) {
            $0.distribution(.fill).spacing(0)
        }
        addSubview(stackView)
        stackView.edgesToSuperview()
        spinner.startSpinning()
        spinner.height(30)
    }
}

extension StackViewStyling where Self: ScrollView {
    var stackView: UIStackView {
        guard let stackView = contentView as? UIStackView else {
            incorrectImplementation("Should be stackview")
        }
        return stackView
    }
}

// MARK: - Private
private extension ScrollView {
    func privateSetup() {
        setupContentView()
        contentInsetAdjustmentBehavior = .always
        
        if self is PullToRefreshCapable {
            setupRefreshControl()
        }
        setup()
    }

    func setupContentView() {
        let contentView = makeView()
        self.contentView = contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.widthToSuperview()
        contentView.leadingToSuperview()
        contentView.trailingToSuperview()
        contentView.topToSuperview()
        contentView.bottomToSuperview(usingSafeArea: true)
    }

    func makeView() -> UIView {
        guard let viewProvider = self as? ContentViewProvider else { incorrectImplementation("should conform to `ContentViewProvider`") }
        return viewProvider.makeContentView()
    }

    func setupRefreshControl() {
        alwaysBounceVertical = true
        let refreshControl = UIRefreshControl(frame: .zero)

        refreshControl.tintColor = .clear // hiding bundled spinner
        let refreshControlCustomView = RefreshControlCustomView()
        refreshControl.addSubview(refreshControlCustomView)
        refreshControlCustomView.bounds = refreshControl.bounds
        self.refreshControlCustomView = refreshControlCustomView
        self.refreshControl = refreshControl
        setRefreshControlTitle(€.title)
        refreshControl.beginRefreshing()
    }
}

// MARK: - Rx
extension Reactive where Base: ScrollingStackView, Base: PullToRefreshCapable {
    var isRefreshing: Binder<Bool> {
        return base.refreshControl!.rx.isRefreshing
    }

    var pullToRefreshTitle: Binder<String> {
        return Binder<String>(base) {
            $0.setRefreshControlTitle($1)
        }
    }

    var pullToRefreshTrigger: Driver<Void> {
        return base.refreshControl!.rx.controlEvent(.valueChanged)
            .asDriverOnErrorReturnEmpty()
    }
}
