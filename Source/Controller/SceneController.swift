//
//  SceneController.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift

/// The "Single-Line Controller" base class
class SceneController<View: ContentView>: AbstractController where View.ViewModel.Input.FromController == InputFromController {
    typealias ViewModel = View.ViewModel

    private let bag = DisposeBag()
    private let viewModel: ViewModel
    private lazy var rootContentView = View()

    // MARK: - Initialization
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .deepBlue
        rootContentView.backgroundColor = .clear
        view.addSubview(rootContentView)
        rootContentView.edgesToSuperview()
        //        if let scrollingStackView = rootContentView as? AbstractSceneView {
        //            scrollingStackView.stackView.height(to: view)
        //        }
        //        rootContentView.heightToSuperview()

        if let titled = self as? TitledScene, case let sceneTitle = titled.sceneTitle, !sceneTitle.isEmpty {
            self.title = sceneTitle
        }
        if let rightButtonMaker = self as? RightBarButtonContentMaking {
            rightButtonMaker.setRightBarButton(for: self)
        }

        if let leftButtonMaker = self as? LeftBarButtonContentMaking {
            leftButtonMaker.setLeftBarButton(for: self)
        }

        if self is BackButtonHiding {
            navigationItem.hidesBackButton = true
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !(self is BackButtonHiding)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyLayoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logSceneAppearanceToAnalyticsIfAllowed()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func handleKeyboardWillShow(_ keyboardSize: CGSize) {
        guard
            let scrollingStackView = rootContentView as? AbstractSceneView,
            case let scrollView = scrollingStackView.scrollView else {
            return
        }
        scrollView.contentInset.bottom = keyboardSize.height
    }

    override func handleKeyboardWillHide() {
        guard
            let scrollingStackView = rootContentView as? AbstractSceneView,
            case let scrollView = scrollingStackView.scrollView else {
                return
        }
        scrollView.contentInset.bottom = 0
    }
}

// MARK: Private
private extension SceneController {

    func setup() {
//        extendedLayoutIncludesOpaqueBars = true
        bindViewToViewModel()
    }

    // swiftlint:disable:next function_body_length
    func makeAndSubscribeToInputFromController() -> InputFromController {
        let titleSubject = PublishSubject<String>()
        let leftBarButtonContentSubject = PublishSubject<BarButtonContent>()
        let rightBarButtonContentSubject = PublishSubject<BarButtonContent>()
        let toastSubject = PublishSubject<Toast>()

        bag <~ [
            titleSubject.asDriverOnErrorReturnEmpty().do(onNext: { [unowned self] in
                self.title = $0
            }).drive(),

            toastSubject.asDriverOnErrorReturnEmpty().do(onNext: { [unowned self] in
                $0.present(using: self)
            }).drive(),

            leftBarButtonContentSubject.asDriverOnErrorReturnEmpty().do(onNext: { [unowned self] in
                self.setLeftBarButtonUsing(content: $0)
            }).drive(),

            rightBarButtonContentSubject.asDriverOnErrorReturnEmpty().do(onNext: { [unowned self] in
                self.setRightBarButtonUsing(content: $0)
            }).drive()
        ]
        return InputFromController(
            viewDidLoad: rx.viewDidLoad,
            viewWillAppear: rx.viewWillAppear,
            viewDidAppear: rx.viewDidAppear,
            leftBarButtonTrigger: leftBarButtonSubject.asDriverOnErrorReturnEmpty(),
            rightBarButtonTrigger: rightBarButtonSubject.asDriverOnErrorReturnEmpty(),
            titleSubject: titleSubject,
            leftBarButtonContentSubject: leftBarButtonContentSubject,
            rightBarButtonContentSubject: rightBarButtonContentSubject,
            toastSubject: toastSubject
        )
    }

    func bindViewToViewModel() {
        let inputFromView = rootContentView.inputFromView
        let inputFromController = makeAndSubscribeToInputFromController()

        let input = ViewModel.Input(fromView: inputFromView, fromController: inputFromController)

        // Transform input from view and controller into output used to update UI
        // Navigatoin logic is handled by the Coordinator listening to navigation
        // steps in passed to the ViewModels `navigator` (`Stepper`).
        let output = viewModel.transform(input: input)

        // Update UI, dispose the array of `Disposable`s
        rootContentView.populate(with: output).forEach { $0.disposed(by: bag) }
    }

//    func applyLayoutIfNeeded() {
//
//        guard let barLayoutOwner = self as? NavigationBarLayoutOwner else {
//            // Default to transluscent
//            navigationController?.applyLayout(.opaque)
//            return
//        }
//
//        navigationController?.applyLayout(barLayoutOwner.navigationBarLayout)
//    }

    func applyLayoutIfNeeded() {
        guard let barLayoutingNavController = navigationController as? NavigationBarLayoutingNavigationController else {
            incorrectImplementation("navigationController should be instance of `NavigationBarLayoutingNavigationController`")
        }

        guard let barLayoutOwner = self as? NavigationBarLayoutOwner else {
            barLayoutingNavController.applyLayout(.opaque)
            return
        }

        if let lastLayout = barLayoutingNavController.lastLayout {
            let layout = barLayoutOwner.navigationBarLayout
            guard layout != lastLayout else {
                // do not apply layout if same, to avoid potential gui glitches
                return
            }
               barLayoutingNavController.applyLayout(layout)
        } else {
            // always apply layout if this is the first scene of this navigation controller
            barLayoutingNavController.applyLayout(barLayoutOwner.navigationBarLayout)
        }
    }

    func logSceneAppearanceToAnalyticsIfAllowed() {
        guard Preferences.default.isTrue(.hasAcceptedAnalyticsTracking) else { return }
        GlobalTracker.shared.track(scene: self)
    }
}
