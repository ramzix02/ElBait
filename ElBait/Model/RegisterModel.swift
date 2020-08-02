//
//  RegisterModel.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 8/1/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation

// MARK: - RegisterModel
struct RegisterModel: Codable {
    let code, message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int
    let email, firstName, lastName, name: String
    let gender, dateOfBirth: JSONNull?
    let phone: String
    let status: JSONNull?
    let group: Group
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case name, gender
        case dateOfBirth = "date_of_birth"
        case phone, status, group
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Group
struct Group: Codable {
    let id: Int
    let name: String
    let createdAt, updatedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
