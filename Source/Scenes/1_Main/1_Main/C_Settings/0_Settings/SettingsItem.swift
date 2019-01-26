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

typealias SettingsItem = NavigatingCellModel<SettingsViewModel.NavigationStep>

protocol CellModel {
    var labelStyle: UILabel.Style { get }
    var imageViewStyle: UIImageView.Style { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
}

struct NavigatingCellModel<Destination> {

    let destination: Destination
    let accessoryType: UITableViewCell.AccessoryType

    private let title: String
    private let icon: UIImage?
    private let style: Style

    fileprivate init(title: String, icon: UIImage?, destination: Destination, style: Style, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator) {
        self.title = title
        self.icon = icon
        self.destination = destination
        self.style = style
        self.accessoryType = accessoryType
    }
}

extension NavigatingCellModel: CellModel {
    var labelStyle: UILabel.Style {
        var labelStyle = style.labelStyle
        labelStyle.text = title
        return labelStyle
    }

    var imageViewStyle: UIImageView.Style {
        var imageViewStyle: UIImageView.Style = .default
        imageViewStyle.image = icon
        imageViewStyle.tintColor = style.iconTintColor
        return imageViewStyle
    }
}

extension NavigatingCellModel {
    enum Style {
        case normal, destructive
    }
}

extension NavigatingCellModel.Style {
    var labelStyle: UILabel.Style {
        switch self {
        case .normal, .destructive: return .body
        }
    }

    var iconTintColor: UIColor {
        switch self {
        case .normal: return .teal
        case .destructive: return .bloodRed
        }
    }
}

extension NavigatingCellModel {
    static func whenSelectedNavigate(
        to destination: Destination,
        titled title: String,
        icon: UIImage?,
        style: Style = .normal,
        accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    ) -> NavigatingCellModel {
        return NavigatingCellModel(title: title, icon: icon, destination: destination, style: style, accessoryType: accessoryType)
    }

    static func whenSelectedNavigate(
        to destination: Destination,
        titled title: String,
        icon: ImageAsset,
        style: Style = .normal,
        accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
        ) -> NavigatingCellModel {
        return whenSelectedNavigate(to: destination, titled: title, icon: icon.image, style: style, accessoryType: accessoryType)
    }
}

