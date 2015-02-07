//
//  System.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Entish
import SwiftDataStructures
import SwiftConfig
import LlamaKit
import Funky


public typealias SystemID = UInt64

public protocol ISystem: class
{
    var systemID: Systems { get }

    func didMoveToController(controller:EntityController)
    func willMoveFromController()

    func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    func removeComponentForEntity(entityID: Entity.EntityID) -> IComponent?

    func createComponentForEntity(entity:Entity, config:Config) -> Result<IComponent>
//    func componentForEntity(entityID: Entity.EntityID) -> IComponent?
}



public class System
{
    public var components = List<IComponent>()

    public init() {
    }

    public func removeComponentForEntity(entityID: Entity.EntityID) {
        if let index = components.find({ $0.entityID == entityID }) {
            components.removeAtIndex(index)
        }
    }

    public func componentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = components.find({ $0.entityID == entityID }) {
            return components[index]
        }
        return nil
    }
}





