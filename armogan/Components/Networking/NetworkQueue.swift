//
//  NetworkQueue.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class NetworkQueue: OperationQueue {
    override init() {
        super.init()

        maxConcurrentOperationCount = 3
    }

    @nonobjc func addOperation(_ operation: NetworkOperation) {
        guard let operations = operations as? [NetworkOperation] else {
            fatalError("The \(String(describing: self)) should only execuste \(String(describing: NetworkOperation.self))")
        }

        if let operation = operations.filter({ $0.id == operation.id }).first {
            operation.cancel()
        }

        super.addOperation(operation)
    }

    func addOperations(_ operations: [NetworkOperation]) {
        operations.forEach(addOperation)
    }
}

extension NetworkQueue {
    @objc override func addOperation(_ op: Operation) {
        fatalError("Use the custom addOperation method")
    }

    override func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool) {
        fatalError("Use the custom addOperations method")
    }

    override func addOperation(_ block: @escaping () -> Swift.Void) {
        fatalError("Use the custom addOperation method")
    }
}
