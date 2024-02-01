//
//  ManagedFeedImage.swift
//  SecondtryEssential
//
//  Created by Amir on 2/1/24.
//

import Foundation
import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
    
    
    static func images(from localFeed: [LocalFeedItem], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.imageURL
            return managed
        })
    }
    
    var local: LocalFeedItem {
        return LocalFeedItem(id: id, description: imageDescription, location: location, imageURL: url)
    }
}
