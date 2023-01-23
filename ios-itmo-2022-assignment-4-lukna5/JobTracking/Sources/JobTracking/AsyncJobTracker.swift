//
//  AsyncJobTracker.swift
//
//
//  Created by mac on 19.11.2022.
//

import Foundation
import Combine

public class AsyncJobTracker<Key: Hashable, Output, Failure: Error>: AsyncJobTracking {
    
    var memoizing: MemoizationOptions = []
    var worker: JobWorker<Key, Output, Failure>
    var dictManager: DictActor
    
    public actor DictActor {
        var dict: [Key: Task<Output, Error>] = [:]
        let worker: JobWorker<Key, Output, Failure>
        
        init(worker: @escaping JobWorker<Key, Output, Failure>) {
            self.worker = worker
        }
        
        func getTask(key: Key) -> Task<Output, Error>? {
            return dict[key]
        }
        
        func createTask(key: Key) -> Task<Output, Error> {
            let task = Task() { () async throws -> Output in
                return try await withCheckedThrowingContinuation({continuation in
                    self.worker(key, {(res) -> Void in
                        switch res {
                        case .success(let out) :
                            continuation.resume(returning: out)
                        case .failure(let err) :
                            continuation.resume(throwing: err)
                        }
                    })
                })
            }
            return task
        }
        func checkTask(key: Key) -> Task<Output, Error> {
            if let task = dict[key] {
                return task
            } else {
                let task = Task() { () async throws -> Output in
                    return try await withCheckedThrowingContinuation({continuation in
                        self.worker(key, {(res) -> Void in
                            switch res {
                            case .success(let out) :
                                continuation.resume(returning: out)
                            case .failure(let err) :
                                continuation.resume(throwing: err)
                            }
                        })
                    })
                }
                dict[key] = task
                return task
            }
        }
    }
    
    public required init(memoizing: MemoizationOptions, worker: @escaping JobWorker<Key, Output, Failure>) {
        self.memoizing = memoizing
        self.worker = worker
        self.dictManager = DictActor(worker: self.worker)
    }
    
    public func startJob(for key: Key) async throws -> Output {
        let task: Task<Output, Error>
        if memoizing.contains(.started) {
            task = await dictManager.checkTask(key: key)
        } else {
            task = await dictManager.createTask(key: key)
        }
        
        switch await task.result {
        case .success(let out) :
            return out
        case .failure(let err) :
            throw err
        }
    }
}
