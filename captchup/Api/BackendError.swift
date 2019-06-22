//
//  BackendError.swift
//  captchup
//
//  Created by Celia Casagrande on 22/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}
