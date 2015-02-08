//
//  PhysicsComponent.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 2.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftBitmask
import SpriteKit
import SwiftConfig
import LlamaKit
import Funky
import GameObjects


/**
    A builder class that produces `PhysicsComponent`s.  It exists exclusively to prevent the
    type parameter `T` from spilling into the `PhysicsComponent` class.
 */
public class PhysicsComponentBuilder <T: IBitmaskRepresentable where T: IConfigRepresentable, T.BitmaskRawType == UInt32>
{
    public class func build(#config:Config) -> Result<PhysicsComponent>
    {
        return config.get("physics body", builder: SKPhysicsBodyBuilder<T>())
                    >>- { PhysicsComponent(entityID: Entity.newID(), physicsBody: $0) |> success }
    }
}


/**
    A component providing its `Entity` with an `SKPhysicsBody`.
 */
public final class PhysicsComponent: IComponent
{
    /** The unique ID of this component's system. */
    public let systemID: Systems = .Physics

    /** The unique ID of the entity to which this component belongs. */
    public var entityID:    Entity.EntityID

    /** The `SKPhysicsBody` that this component provides to its `Entity`. */
    public var physicsBody: SKPhysicsBody

    /** The designated initializer. */
    public init(entityID eid:Entity.EntityID, physicsBody pb:SKPhysicsBody) {
        entityID = eid
        physicsBody = pb
    }
}


extension PhysicsComponent: Printable, DebugPrintable {
    public var description:      String { return "<PhysicsComponent { physicsBody = \(physicsBody.description) }>" }
    public var debugDescription: String { return description }
}




