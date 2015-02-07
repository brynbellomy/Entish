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


public final class PhysicsComponent <T: IBitmaskRepresentable where T: IConfigRepresentable, T.BitmaskRawType == UInt32> : IComponent
{
    public class func build(#config:Config) -> Result<PhysicsComponent>
    {
        return config.get("physics body", builder: SKPhysicsBodyBuilder<T>())
                    >>- { PhysicsComponent(entityID: Entity.newID(), physicsBody: $0) |> success }
    }

    public let systemID: Systems = .Physics

    public var entityID:    Entity.EntityID
    public var physicsBody: SKPhysicsBody

    public init(entityID eid:Entity.EntityID, physicsBody pb:SKPhysicsBody) {
        entityID = eid
        physicsBody = pb
    }
}
