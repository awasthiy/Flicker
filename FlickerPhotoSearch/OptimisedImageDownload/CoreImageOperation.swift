//
//  CoreImageOperation.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 26/06/2020.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import Foundation

typealias CoreImageCompletion = ((_ data: Data?, _ indexSpecificForCell: IndexPath?, _ key: URL)->Void)

final class CoreImageOperation: Operation {
    
    enum States {
        case isExecuting
        case isFinished
    }
    
    
    // MARK: An Opertaion can be Synchronous or Asynchronous. Developer can choose between the two what to use. Operation objects are Sync by default.
    
    override var isAsynchronous: Bool{
        get { return true }
    }
    
    
    // MARK: isExecuting + isFinished properties are to be overriden while subclassing Operation. It gives us a better control over our current implementation of Operation plus we get to know what is the current state of our Operation. isExecuting & isFinished are KVO + KVC compliant.
    
    override var isExecuting: Bool {
        return observantForIsExecuting
    }
    
    override var isFinished: Bool {
        return observantForIsFinised
    }
    
    private var observantForIsExecuting: Bool = false {
        willSet{
            willChangeValue(forKey: Constants.isExecuting)
        }
        didSet {
            didChangeValue(forKey: Constants.isExecuting)
        }
    }
    
    private var observantForIsFinised: Bool = false {
        willSet {
            willChangeValue(forKey: Constants.isFinished)
        }
        didSet {
            didChangeValue(forKey: Constants.isFinished)
        }
    }
    
    
    
    // MARK: Best part with subclassing Operation and calling the completionBlock it gets called exactly once, gives a nice way to customise a behaviour in a model or a class.
    
    var onCompletion: CoreImageCompletion?
    let url: URL
    let indexPath: IndexPath?
    
    
    @discardableResult
    init(url: URL, indexPath: IndexPath?) {
        self.url = url
        self.indexPath = indexPath
        super.init()
    }
    
    
    // MARK: Here overriding of start() method is not done, coz this operation is non-concurrent. When we override isConcurrent then we dont implement main() method instead override the start method. In both the methods it is documented that super must not be called. Even is we do implement main() method in while we mark our operation as concurrent, then we call main() in the custom implementation of start() method.
    
//    override func start() {
//        if isCancelled {
//            alterState(operation: (.isFinished, true))
//            return
//        }
//        main()
//    }
    
    override func main() {
        if isCancelled {
            alterState(operation: (.isFinished, true))
            return
        }
        alterState(operation: (.isExecuting, true))
        self.getImage()
    }
}


private extension CoreImageOperation {
    
    func alterState(operation: (CoreImageOperation.States,Bool)) {
        
        switch operation.0 {
            
        case .isExecuting:
            observantForIsExecuting = operation.1
            
        case .isFinished:
            observantForIsFinised = operation.1
        }
    }
    
    func getImage() {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let passImageData = data {
                self.onCompletion?(passImageData as Data, self.indexPath, self.url)
            }
            self.alterState(operation: (.isFinished, true))
            self.alterState(operation: (.isExecuting, false))
        }.resume()
    }
}
