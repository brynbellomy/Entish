//
//  EntityController.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftBitmask
import BrynSwift
import Funky


public struct EntityController <T: IBitmaskRepresentable>
{
    public typealias EntityID = Entity<T>.EntityID

    private var entities = Controller<EntityID, Entity<T>>()

    public init() {
    }

    public func entitiesWithComponents(components:Bitmask<T>) -> [Entity<T>]
    {
        return entities.sequence()
                    |> map‡ (takeRight)
                    |> filter‡ { ($0.componentBitmask & components) != Bitmask<T>.allZeros }
    }

    mutating
    public func addEntity(entity:Entity<T>) {
        entities[entity.uuid] = entity
    }

    mutating
    public func removeEntity(id:EntityID) {
        entities.remove(id)
    }
}

