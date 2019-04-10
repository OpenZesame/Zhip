// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

import RxSwift

/// The "Single-Line Controller" base class
class SceneController<View: ContentView>: AbstractController where View.ViewModel.Input.FromController == InputFromController {
    typealias ViewModel = View.ViewModel

    private let bag = DisposeBag()
    let viewModel: ViewModel
    
    private lazy var rootContentView: View = {
        // Beware, here be dragons!
        // For some unknown reason (Xcode 10.2 / Swift 5 being drunk) Xcode decided to interpret `View()` (which worked fine before Xcode 10.2)
        // as `UIView.init:frame:`. Why? Oh Why?! This terribly ugly hack fixes that.
        // swiftlint:disable force_cast
        return (View.self as EmptyInitializable.Type).init() as! View
    }()

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
}

// MARK: Private
private extension SceneController {

    func setup() {
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
}
