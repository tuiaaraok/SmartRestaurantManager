//
//  CoreDataManager.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//


import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmartRestaurantManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveProduct(productModel: ProductModel, completion: @escaping (Error?) -> Void) {
        let id = productModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let product: Product
                
                if let existingProduct = results.first {
                    product = existingProduct
                } else {
                    product = Product(context: backgroundContext)
                    product.id = id
                }
                
                product.name = productModel.name
                product.price = productModel.price
                product.category = Int32(productModel.category ?? 0)
                product.info = productModel.info
                product.rating = productModel.rating
                product.photo = productModel.photo
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchProducts(completion: @escaping ([ProductModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var productsModel: [ProductModel] = []
                for result in results {
                    let productModel = ProductModel(id: result.id ?? UUID(), name: result.name, price: result.price, category: Int(result.category), info: result.info, rating: result.rating, photo: result.photo)
                    productsModel.append(productModel)
                }
                DispatchQueue.main.async {
                    completion(productsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func removeProduct(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let product = results.first {
                    backgroundContext.delete(product)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
//    func changeTaskStatus(id: UUID, status: Int, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                if let order = results.first {
//                    order.status = Int32(status)
//                } else {
//                    completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"]))
//                }
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    

//    
//    func saveTip(tipModel: TipModel, completion: @escaping (Error?) -> Void) {
//        let id = tipModel.id
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Tip> = Tip.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                let tip: Tip
//                
//                if let existingTip = results.first {
//                    tip = existingTip
//                } else {
//                    tip = Tip(context: backgroundContext)
//                    tip.id = id
//                }
//                
//                tip.info = tipModel.info
//                tip.header = tipModel.header
//                
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchTips(completion: @escaping ([TipModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Tip> = Tip.fetchRequest()
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var tipsModel: [TipModel] = []
//                for result in results {
//                    let tipModel = TipModel(id: result.id ?? UUID(), header: result.header, info: result.info)
//                    tipsModel.append(tipModel)
//                }
//                DispatchQueue.main.async {
//                    completion(tipsModel, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
}

