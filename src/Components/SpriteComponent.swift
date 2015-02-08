//
//  SpriteComponent.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 3.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import LlamaKit
import SwiftConfig
import Funky
import GameObjects


/**
    A component providing its `Entity` with an `SKSpriteNode`.  The sprite node is automatically
    added to the `Entity`'s `SKNode` (which it acquires from `NodeComponent`).

    Required components: `NodeComponent`
 */
public final class SpriteComponent: IComponent, IConfigBuildable
{
    /** This function is implemented for `SwiftConfig.IConfigBuildable` conformance. */
    public class func build(#config:Config) -> Result<SpriteComponent>
    {
        return buildSpriteComponent(Entity.newID())
                    <^> config.get("sprite node", builder:SKSpriteNodeBuilder())
                                    ?± failure("Could not get value for key 'sprite node'.")
    }

    /** The unique ID of this component's system. */
    public let systemID: Systems = .Sprite

    /** The unique ID of the entity to which this component belongs. */
    public var entityID: Entity.EntityID

    /** The `SKSpriteNode` that this component provides to its `Entity`. */
    public var spriteNode: SKSpriteNode

    /** The designated initializer. */
    public init(entityID eid:Entity.EntityID, spriteNode sn:SKSpriteNode) {
        entityID = eid
        spriteNode = sn
    }
}


private func buildSpriteComponent (entityID:Entity.EntityID) (spriteNode:SKSpriteNode) -> SpriteComponent {
    return SpriteComponent(entityID:entityID, spriteNode:spriteNode)
}


extension SpriteComponent: Printable, DebugPrintable {
    public var description:      String { return "<SpriteComponent { spriteNode = \(spriteNode) }>" }
    public var debugDescription: String { return description }
}


