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
    
    func saveEmployee(employeeModel: EmployeeModel, completion: @escaping (Error?) -> Void) {
        let id = employeeModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let employee: Employee
                
                if let existingEmployee = results.first {
                    employee = existingEmployee
                } else {
                    employee = Employee(context: backgroundContext)
                    employee.id = id
                }
                
                employee.name = employeeModel.name
                employee.position = Int32(employeeModel.position ?? 1)
                employee.startOfShift = employeeModel.startOfShift
                employee.endOfShift = employeeModel.endOfShift
                employee.datesOfShift = employeeModel.datesOfShift
                
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
    
    func fetchEmployees(completion: @escaping ([EmployeeModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var employeesModel: [EmployeeModel] = []
                for result in results {
                    let employeeModel = EmployeeModel(id: result.id ?? UUID(), name: result.name, position: Int(result.position), startOfShift: result.startOfShift, endOfShift: result.endOfShift, datesOfShift: result.datesOfShift)
                    employeesModel.append(employeeModel)
                }
                DispatchQueue.main.async {
                    completion(employeesModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func saveEvent(eventModel: EventModel, completion: @escaping (Error?) -> Void) {
        let id = eventModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let event: Event
                
                if let existingEvent = results.first {
                    event = existingEvent
                } else {
                    event = Event(context: backgroundContext)
                    event.id = id
                }
                
                event.name = eventModel.name
                event.numberGuests = Int64(eventModel.numberGuests ?? 0)
                event.date = eventModel.date
                event.startTime = eventModel.startTime
                event.endTime = eventModel.endTime
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
    
    func fetchEvents(completion: @escaping ([EventModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var eventsModel: [EventModel] = []
                for result in results {
                    let eventModel = EventModel(id: result.id ?? UUID(), name: result.name, numberGuests: Int(result.numberGuests), date: result.date, startTime: result.startTime, endTime: result.endTime)
                    eventsModel.append(eventModel)
                }
                DispatchQueue.main.async {
                    completion(eventsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
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

