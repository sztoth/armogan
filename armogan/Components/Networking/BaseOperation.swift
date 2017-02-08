//
//  BaseOperation.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class BaseOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }

    fileprivate var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    override func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            main()
        }
    }

    func finish() {
        state = .finished
    }
}

fileprivate extension BaseOperation {
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"

        var keyPath: String {
            return "is" + self.rawValue
        }
    }
}
