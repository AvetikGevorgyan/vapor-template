import FluentSQLite
import Vapor
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentSQLiteProvider())
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    
    // CORS Middleware | should be first in middleware list
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    middlewares.use(corsMiddleware)
    middlewares.use(ErrorMiddleware.self)
    
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let directory = DirectoryConfig.detect().workDir
    let sqlite = try SQLiteDatabase(storage: .file(path: "\(directory)database.db"))

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    // Configure migrations
//    var migrations = MigrationConfig()
//    migrations.add(model: Start.self, database: .sqlite)
//    services.register(migrations)
}
