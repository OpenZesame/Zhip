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

typealias TableViewSceneView<Header, Cell: ListCell> = BaseTableViewOwner<Header, Cell> & TableViewOwner

typealias HeaderlessTableViewSceneView<Cell: ListCell> = TableViewSceneView<Void, Cell>

class BaseTableViewOwner<Header, Cell>: AbstractSceneView where Cell: ListCell {

    let tableView: SingleCellTypeTableView<Header, Cell>

    // MARK: - Initialization
    init(style: UITableView.Style) {
        tableView = SingleCellTypeTableView(style: style)
        super.init(scrollView: tableView)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}
