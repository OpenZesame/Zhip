// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine

protocol ViewModelled: EmptyInitializable {
    associatedtype ViewModel: ViewModelType
    typealias InputFromView = ViewModel.Input.FromView
    var inputFromView: InputFromView { get }
    func populate(with viewModel: ViewModel.OutputVM) -> [AnyCancellable]
}

extension ViewModelled {
    func populate(with _: ViewModel.OutputVM) -> [AnyCancellable] { [] }
}

struct NoControllerInput {}
extension ViewModelled where ViewModel.Input.FromController == NoControllerInput {
    var input: ViewModel.Input {
        ViewModel.Input(fromView: inputFromView, fromController: NoControllerInput())
    }
}
