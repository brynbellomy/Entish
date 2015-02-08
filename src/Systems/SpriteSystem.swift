//
//  SpriteSystem.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 6.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftDataStructures
import LlamaKit
import Funky
import SwiftConfig


public class SpriteSystem: ISystem
{
    /** The unique system ID of this system. */
    public let systemID: Systems = .Sprite

    private var base = SystemBase<SpriteComponent, EntityView>()


    //
    // MARK: - Lifecycle
    //

    /** The designated initializer. */
    public init() {
    }


    public func didMoveToController(controller:EntityController) {
        base.didMoveToController(controller)
    }


    public func willMoveFromController() {
        base.willMoveFromController()
    }


    //
    // MARK: - Public API
    //

    public func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    {
        let spriteComponent: SpriteComponent? = getTypedComponent(components, .Sprite)
        let nodeComponent:   NodeComponent?   = getTypedComponent(components, .Node)

        if let (sprite, node) = both(spriteComponent, nodeComponent)
        {
            let entityView = EntityView(entityID:entity.uuid, sprite:sprite, node:node)
            base.addEntityView(entityView)

            // add the `SKSpriteNode` to the `SKNode`
            node.node.addChild(sprite.spriteNode)

            return success()
        }
        else { return failure("SpriteSystem could not get NodeComponent for entity (entityID: \(entity.uuid))") }
    }


    public func removeComponentForEntity(entityID: Entity.EntityID) -> IComponent? {
        return base.removeComponentForEntity(entityID)
    }


    public func componentForEntity(entityID: Entity.EntityID) -> IComponent? {
        return base.componentForEntity(entityID)
    }



    /** Private helper struct to keep references to other components containing data used by this system. */
    private struct EntityView: ISystemEntityView
    {
        let entityID:        Entity.EntityID
        var homeComponent: IComponent { return spriteComponent }

        var spriteComponent: SpriteComponent
        var nodeComponent:   NodeComponent

        init(entityID eid:Entity.EntityID, sprite s:SpriteComponent, node n:NodeComponent)
        {
            entityID = eid
            spriteComponent = s
            nodeComponent = n
        }
    }
}




