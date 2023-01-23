//
//  GCDJobTracker.swift
//
//
//  Created by mac on 19.11.2022.
//

import Foundation
import Combine

public class GCDJobTracker<Key: Hashable, Output, Failure: Error>: CallbackJobTracking {
    
    var memoizing: MemoizationOptions
    var worker: JobWorker<Key, Output, Failure>
    var dict: [Key: Result<Output, Failure>?] = [:]
    var dictComp: [Key: [(Result<Output, Failure>) -> Void]] = [:]
    let globalAsync = DispatchQueue(label: "GCDAsyncQueue", attributes: .concurrent)
    let globalSync = DispatchQueue(label: "GCDSyncQueue")
    
    public required init(memoizing: MemoizationOptions, worker: @escaping JobWorker<Key, Output, Failure>) {
        self.memoizing = memoizing
        self.worker = worker
    }
    
    public func startJob(for key: Key, completion: @escaping (Result<Output, Failure>) -> Void) {
        globalSync.sync {
            if let res = dict[key] {
                switch res {
                case .success(let out):
                    if self.memoizing.contains(.succeeded) {
                        completion(.success(out))
                    }
                case .failure(let err):
                    if self.memoizing.contains(.failed) {
                        completion(.failure(err))
                    }
                case nil:
                    dictComp[key, default: []].append({ (res) -> Void in
                        self.parseRes(completion: completion, res: res)
                    })
                }
            } else {
                self.dict[key] = nil
                globalAsync.async {
                    self.worker(key, {(res) -> Void in
                        self.parseRes(completion: completion, res: res)
                        if self.memoizing.contains(.started) {
                            self.globalSync.sync {
                                self.dict[key] = res
                                for comp in self.dictComp[key, default: []] {
                                    comp(res)
                                }
                                self.dictComp.removeValue(forKey: key)
                            }
                        }
                    })
                }
            }
        }
    }
    
    private func parseRes(completion: @escaping (Result<Output, Failure>) -> Void, res: Result<Output, Failure>?){
        switch res {
        case .success(let out):
            if self.memoizing.contains(.succeeded) {
                completion(.success(out))
            }
        case .failure(let err):
            if self.memoizing.contains(.failed) {
                completion(.failure(err))
            }
        case .none:
            break
        }
    }
}
