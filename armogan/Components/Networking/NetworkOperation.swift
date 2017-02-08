//
//  NetworkOperation.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class NetworkOperation: BaseOperation {
    let id: UUID

    var onStart: (() -> Void)?
    var onCompleted: ((Forecast?, Error?) -> Void)?

    fileprivate let session: URLSession
    fileprivate let resource: NetworkResource

    fileprivate var task: URLSessionDataTask?

    init(session: URLSession = URLSession.shared, id: UUID, resource: NetworkResource) {
        self.session = session
        self.id = id
        self.resource = resource
    }

    override func main() {
        executeOnMainThread { self.onStart?() }

        //performNetworkRequest()

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.0) {
            let path = Bundle.main.url(forResource: "test", withExtension: "json")!
            let data = try! Data(contentsOf: path, options: [])
            let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let forecast = self.resource.forecast(from: dict)

            self.handle(forecast: forecast, error: nil)
        }
    }

    override func cancel() {
        task?.cancel()

        super.cancel()
    }
}

fileprivate extension NetworkOperation {
    func executeOnMainThread(_ block: @escaping () -> ()) {
        DispatchQueue.main.async(execute: block)
    }

    func performNetworkRequest() {
        let dataTask = session.dataTask(with: resource.url) { [weak self] (data, response, error) in
            guard let `self` = self else { return }

            guard error == nil else {
                self.handle(forecast: nil, error: error)
                return
            }

            guard
                let dict = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String: Any],
                let forecast = self.resource.forecast(from: dict)
            else {
                self.handle(forecast: nil, error: OperationError.serializationFailure)
                return
            }
        
            self.handle(forecast: forecast, error: nil)
        }
        dataTask.resume()

        task = dataTask
    }

    func handle(forecast: Forecast?, error: Error?) {
        executeOnMainThread { self.onCompleted?(forecast, error) }

        finish()
    }
}

extension NetworkOperation {
    enum OperationError: Error {
        case serializationFailure
    }
}
