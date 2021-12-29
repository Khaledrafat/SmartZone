//
//  CoreDataBase.swift
//  Task
//
//  Created by Khaled on 28/12/2021.
//

import CoreData
import UIKit

class CoreDataBase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Get All Data
    func getAllData() -> [ArticleCD]? {
        do {
            let item = try context.fetch(ArticleCD.fetchRequest()) as? [ArticleCD]
            return item
        } catch {
            print("CORE DATA ERROR \(error.localizedDescription)")
            return nil
        }
    }
    
    //MARK: - Delete Item
    func deleteItem(item : ArticleCD) {
        context.delete(item)
        save()
    }
    
    //MARK: - Create Item
    func createItem(item : Article) {
        let newItem = ArticleCD(context: context)
        newItem.name = item.title
        newItem.imgURL = item.urlToImage
        newItem.url = item.url
        newItem.content = item.articleDescription
        newItem.author = item.author
        save()
    }
    
    //MARK: - Save
    private func save() {
        do {
            try context.save()
        } catch {
            print("CORE DATA ERROR \(error.localizedDescription)")
        }
    }
    
}
