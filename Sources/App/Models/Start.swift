//
//  Start.swift
//  App
//
//  Created by Avetik on 08.02.20.
//

import FluentSQLite
import Vapor

/// A single entry of a Start list.
final class Start: SQLiteModel {
    /// The unique identifier for this `Start`.
    var id: Int?
    
    /// A title describing what this `Start` entails.
    var title: String
    
    /// Creates a new `Start`.
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

/// Allows `Start` to be used as a dynamic migration.
extension Start: Migration { }

/// Allows `Start` to be encoded to and decoded from HTTP messages.
extension Start: Content { }

/// Allows `Start` to be used as a dynamic parameter in route definitions.
extension Start: Parameter { }

