//
//  ArticleCD+CoreDataProperties.swift
//  
//
//  Created by Khaled on 28/12/2021.
//
//

import Foundation
import CoreData


extension ArticleCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleCD> {
        return NSFetchRequest<ArticleCD>(entityName: "ArticleCD")
    }

    @NSManaged public var author: String?
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var imgURL: String?
    @NSManaged public var content: String?

}
