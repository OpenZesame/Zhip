//
//  HistoryView.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias History = Scene<HistoryView>

final class HistoryView: UIView {

    private lazy var tableView = UITableView()

}

extension HistoryView: ViewModelled {

    typealias ViewModel = HistoryViewModel

    var inputFromView: ViewModel.Input {
        return ViewModel.Input()
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return []
    }

}

final class HistoryViewModel {}

extension HistoryViewModel: ViewModelType {

    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }

}
