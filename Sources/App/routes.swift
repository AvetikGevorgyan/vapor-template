import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let startController = StartController()
    try router.register(collection: startController)
    }

