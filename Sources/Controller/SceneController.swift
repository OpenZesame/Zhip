// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

/// The "Single-Line Controller" base class.
///
/// `SceneController<View>` is the generic scene glue: given a `ViewModelled` view
/// type and its associated ViewModel, it instantiates the view, builds an
/// `InputFromController`, invokes `viewModel.transform(input:)`, and binds the
/// output back to the view via `View.populate(with:)`. It is almost never
/// subclassed — coordinators push instances of this class directly using the
/// `Scene` typealias.
class SceneController<View: ContentView>: AbstractController
    where View.ViewModel.Input.FromController == InputFromController
// swiftlint:disable:next opening_brace
{
    /// Convenience alias for the view's ViewModel type.
    typealias ViewModel = View.ViewModel

    /// Bag of Combine subscriptions owned by this controller (navigation bar bindings,
    /// toasts, title updates, view ↔ view-model bindings).
    private var cancellables = Set<AnyCancellable>()

    /// The ViewModel injected by the coordinator at construction time.
    let viewModel: ViewModel

    /// Fires when `viewDidLoad` runs. Piped into `InputFromController.viewDidLoad`.
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()

    /// Fires each time `viewWillAppear` runs.
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()

    /// Fires each time `viewDidAppear` runs.
    private let viewDidAppearSubject = PassthroughSubject<Void, Never>()

    /// Lazily-constructed root content view; the `force_cast` is safe because
    /// `View: ContentView` and `ContentView: EmptyInitializable` by convention.
    private lazy var rootContentView: View =
        // swiftlint:disable:next force_cast
        (View.self as EmptyInitializable.Type).init() as! View

    // MARK: - Initialization

    /// Designated initializer. Coordinators call this with a freshly-constructed
    /// ViewModel; `setup()` wires the bindings eagerly so the View has live
    /// publishers before `viewDidLoad` runs.
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    /// Unavailable — Interface Builder is not supported. Traps to enforce the
    /// programmatic-only invariant.
    required init?(coder _: NSCoder) {
        interfaceBuilderSucks
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .deepBlue
        rootContentView.backgroundColor = .clear
        view.addSubview(rootContentView)
        rootContentView.edgesToSuperview()

        if let titled = self as? TitledScene, case let sceneTitle = titled.sceneTitle, !sceneTitle.isEmpty {
            title = sceneTitle
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

        viewDidLoadSubject.send(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyLayoutIfNeeded()
        viewWillAppearSubject.send(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearSubject.send(())
    }
}

// MARK: Private

private extension SceneController {
    func setup() {
        bindViewToViewModel()
    }

    func makeAndSubscribeToInputFromController() -> InputFromController {
        let titleSubject = PassthroughSubject<String, Never>()
        let leftBarButtonContentSubject = PassthroughSubject<BarButtonContent, Never>()
        let rightBarButtonContentSubject = PassthroughSubject<BarButtonContent, Never>()
        let toastSubject = PassthroughSubject<Toast, Never>()

        [
            titleSubject.receive(on: RunLoop.main).sink { [weak self] in self?.title = $0 },
            toastSubject.receive(on: RunLoop.main).sink { [weak self] in
                guard let self else { return }
                $0.present(using: self)
            },
            leftBarButtonContentSubject.receive(on: RunLoop.main).sink { [weak self] in
                self?.setLeftBarButtonUsing(content: $0)
            },
            rightBarButtonContentSubject.receive(on: RunLoop.main).sink { [weak self] in
                self?.setRightBarButtonUsing(content: $0)
            },
        ].forEach { $0.store(in: &cancellables) }

        return InputFromController(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            viewWillAppear: viewWillAppearSubject.eraseToAnyPublisher(),
            viewDidAppear: viewDidAppearSubject.eraseToAnyPublisher(),
            leftBarButtonTrigger: leftBarButtonSubject.eraseToAnyPublisher(),
            rightBarButtonTrigger: rightBarButtonSubject.eraseToAnyPublisher(),
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
        let output = viewModel.transform(input: input)

        rootContentView.populate(with: output).forEach { $0.store(in: &cancellables) }
    }

    func applyLayoutIfNeeded() {
        guard let navigationController else { return }
        guard let barLayoutingNavController = navigationController as? NavigationBarLayoutingNavigationController else {
            incorrectImplementation(
                "navigationController should be instance of `NavigationBarLayoutingNavigationController`"
            )
        }

        guard let barLayoutOwner = self as? NavigationBarLayoutOwner else {
            barLayoutingNavController.applyLayout(.opaque)
            return
        }

        if let lastLayout = barLayoutingNavController.lastLayout {
            let layout = barLayoutOwner.navigationBarLayout
            guard layout != lastLayout else { return }
            barLayoutingNavController.applyLayout(layout)
        } else {
            barLayoutingNavController.applyLayout(barLayoutOwner.navigationBarLayout)
        }
    }
}
