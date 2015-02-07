//
//  Entity.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import BrynSwift
import SwiftBitmask
import SwiftDataStructures


public struct Entity
{
    public typealias EntityID = NSUUID

    public static func newID() -> EntityID {
        return NSUUID()
    }

    public let uuid: EntityID
    public let componentBitmask: Bitmask<Systems>
//    public var components = Controller<SystemID, IComponent>()

    public init(uuid u:EntityID, componentBitmask bitmask:Bitmask<Systems>) {
        uuid = u
        componentBitmask = bitmask
    }

    public func hasComponent(system:Systems) -> Bool {
        return componentBitmask.isSet(system)
    }

//    public func getComponent(system:SystemID) -> IComponent? {
//        if hasComponent(system) {
//            return components[system]!
//        }
//        return nil
//    }
}


