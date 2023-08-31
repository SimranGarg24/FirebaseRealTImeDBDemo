//
//  DatabaseManager.swift
//  FBRealTimeDemo
//
//  Created by Saheem Hussain on 24/08/23.
//

import Foundation
import FirebaseDatabase

class RealTimeDBManager {
    
    // MARK: - properties
    // A Firebase reference points to a location in Firebase where data is stored. Even if you create multiple references, they all share the same connection.
    private var ref: DatabaseReference!
//    private var refHandle: DatabaseHandle?
    private var dataList: [[String: String]] = []
    var lastFetchedKey: String?
    let itemsPerPage = 5 // Number of items to fetch per page
    var currentIndex: Int = 0
    
    static let shared = RealTimeDBManager()
    private init() {}
    
    // MARK: - Methods
    func setUpReference(key: String) {
        ref = Database.database().reference().child(key)
    }
   
    func setObserver(completion: @escaping ([[String: String]]?) -> Void) {
        
        // observing the data changes
        // DataEventType.value :- Read and listen for changes to the entire contents of a path.
        var query = ref.queryOrderedByKey()
        
        if self.dataList.isEmpty {
            query = query.queryLimited(toFirst: UInt(itemsPerPage))
        }
        
        query.observe(.childAdded, with: {(snapshot) in
            
            if snapshot.childrenCount > 0 {
                print("add:", snapshot.children.allObjects)
                
                let dict = snapshot.value as? [String: String]
                if let dict {
                    self.dataList.append(dict)
                }
                completion(self.dataList)
            }
            completion(nil)
        })
        
        ref.observe(.childChanged, with: {(snapshot) in
            
            if snapshot.childrenCount > 0 {
                print("edit:", snapshot.children.allObjects)
                
                let dict = snapshot.value as? [String: String]
                if let dict {
                    self.dataList[self.currentIndex] = dict
                }
                completion(self.dataList)
            }
            completion(nil)
        })
        
        ref.observe(.childRemoved, with: {(snapshot) in
            
            if snapshot.childrenCount > 0 {
                print("delete:", snapshot.children.allObjects)
                if !self.dataList.isEmpty {
                    self.dataList.remove(at: self.currentIndex)
                }
                completion(self.dataList)
            }
            completion(nil)
        })
    }
    
    func getuniquekey() -> String? {
        return ref.childByAutoId().key
    }
    
    func addData(key: String, data: [String: String]?, completion: @escaping (Bool, Error?) -> Void) {
        ref.child(key).setValue(data) { error, _ in
            if let error {
                print("Data could not be saved: \(error).")
                completion(false, error)
            } else {
                print("Data saved successfully.")
                completion(true, nil)
            }
        }
    }
    
    func update(id: String, data: [String: String], completion: @escaping (Bool, Error?) -> Void) {
        addData(key: id, data: data) {success, error in
            if success {
                completion(success, nil)
            } else {
                completion(success, error)
            }
        }
    }
    
    func delete(id: String, completion: @escaping (Bool, Error?) -> Void) {
        
//        ref.child(id).removeValue()
        // or
        addData(key: id, data: nil) {success, error in
            if success {
                completion(success, nil)
            } else {
                completion(success, error)
            }
        }
    }
    
//    Observers don't automatically stop syncing data when you leave a ViewController. If an observer isn't properly removed, it continues to sync data to local memory. When an observer is no longer needed, remove it by passing the associated FIRDatabaseHandle to the removeObserverWithHandle method.
    func removeObserver() {
    }
    
    // get data with paging
    func pagingData(completion: @escaping ([[String: String]]?) -> Void) {
        
        var query = ref.queryOrderedByKey()
        
        if let lastKey = lastFetchedKey {
            query = query.queryStarting(afterValue: lastKey).queryLimited(toFirst: UInt(itemsPerPage))
        } else {
            query = query.queryLimited(toFirst: UInt(itemsPerPage))
        }
        
        query.getData { (_, snapshot) in
            
            // if the reference have some values
            if let snapshot, snapshot.childrenCount > 0 {
                
                var list: [[String: String]] = []
                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {return}
                // iterating through all the values
                for items in snapshots {
                    
                    // getting values
                    let object = items.value as? [String: AnyObject]
                    
                    var dict: [String: String] = [:]
                    
                    for key in object!.keys {
                        dict[key] = object?[key] as? String
                    }
                    
                    // appending it to list
                    list.append(dict)
                }
                self.dataList.append(contentsOf: list)
                completion(self.dataList)
            }
            
            completion(nil)
        }
    }
}
