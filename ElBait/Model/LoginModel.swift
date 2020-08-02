////
////  LoginModel.swift
////  ElBait
////
////  Created by Ahmed Ramzy on 7/30/20.
////  Copyright © 2020 Ahmed Ramzy. All rights reserved.
////
//
import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let code, token, message: String
    let data: MyDataClass
}

// MARK: - DataClass
struct MyDataClass: Codable {
    let id: Int
    let email, firstName, lastName, name: String
    let gender, dateOfBirth: JSONNull?
    let phone, status: String
    let group: MyGroup
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
struct MyGroup: Codable {
    let id: Int
    let name: String
    let createdAt, updatedAt: MyJSONNull?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Encode/decode helpers

class MyJSONNull: Codable, Hashable {
    
    public static func == (lhs: MyJSONNull, rhs: MyJSONNull) -> Bool {
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
