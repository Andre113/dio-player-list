//
//  Reusable.swift
//  PlayerList
//
//  Created by André Lucas Ota on 27/10/21.
//

import Foundation
import UIKit

protocol Reusable { }

extension Reusable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable { }
