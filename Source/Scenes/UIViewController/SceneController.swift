//
//  SceneController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import TinyConstraints

/// The "Single-Line Controller" base class
class SceneController<View: ContentView>: AbstractController where View.ViewModel.Input.FromController == ControllerInput {
    typealias ViewModel = View.ViewModel

    private let bag = DisposeBag()
    private let viewModel: ViewModel

    // MARK: - Initialization
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewToViewModel()
        edgesForExtendedLayout = .bottom
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    // MARK: View Lifecycle
    override func loadView() {
        view = View()
        view.backgroundColor = .white
        view.bounds = UIScreen.main.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let titled = self as? TitledScene, case let sceneTitle = titled.sceneTitle, !sceneTitle.isEmpty {
            self.title = sceneTitle
        }
        if let barButtonMaker = self as? RightBarButtonMaking {
            barButtonMaker.setRightBarButton(for: self)
        }
    }
}

// MARK: Private
private extension SceneController {
    // swiftlint:disable:next function_body_length
    func bindViewToViewModel() {
        guard let contentView = view as? View else { return }

        let titleSubject = PublishSubject<String>()
        let rightBarButtonContentSubject = PublishSubject<BarButtonContent>()
        let toastSubject = PublishSubject<Toast>()

        let controllerInput = ControllerInput(
            viewDidLoad: rx.viewDidLoad,
            viewWillAppear: rx.viewWillAppear,
            viewDidAppear: rx.viewDidAppear,
            leftBarButtonTrigger: leftBarButtonSubject.asDriverOnErrorReturnEmpty(),
            rightBarButtonTrigger: rightBarButtonSubject.asDriverOnErrorReturnEmpty(),
            titleSubject: titleSubject,
            rightBarButtonContentSubject: rightBarButtonContentSubject,
            toastSubject: toastSubject
        )

        bag <~ [
            titleSubject.asDriverOnErrorReturnEmpty().do(onNext: { [unowned self] in
                self.title = $0
            }).drive(),

            toastSubject.asDriverOnErrorReturnEmpty().do(onNext: { [unowned self] in
                $0.present(using: self)
            }).drive(),

            rightBarButtonContentSubject.asDriverOnErrorReturnEmpty().do(onNext: { [unowned self] in
                self.setRightBarButtonUsing(content: $0)
            }).drive()
        ]

        let input = ViewModel.Input(fromView: contentView.inputFromView, fromController: controllerInput)

        let output = viewModel.transform(input: input)

        contentView.populate(with: output).forEach { $0.disposed(by: bag) }
    }
}
