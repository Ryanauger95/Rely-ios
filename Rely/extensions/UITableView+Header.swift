//
//  UITableView+Header.swift
//  Rely
//
//  Created by Ryan Auger on 7/12/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

extension UITableView {
    func addTableHeader(header: String) {
        let headerView: UIView = UIView.init(frame: CGRect(x: 1, y: 50, width: 276, height: 30))
        headerView.backgroundColor = UIColor(rgb: 0xDBDFE7)
        
        let labelView: UILabel = UILabel.init(frame: CGRect(x: 4, y: 5, width: 276, height: 24))
        labelView.text = "     \(header)"
        labelView.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        headerView.addSubview(labelView)
        self.tableHeaderView = headerView
    }
}
