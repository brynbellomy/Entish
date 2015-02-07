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
    public let systemID: Systems = .Sprite
    public var entityController: EntityController?

    private var entities = List<EntityView>()


    //
    // MARK: - Lifecycle
    //

    /** The designated initializer. */
    public init() {
    }


    public func didMoveToController(controller:EntityController) {
        entityController = controller
    }


    public func willMoveFromController() {
        entityController = nil
    }


    //
    // MARK: - Public API
    //

    public func createComponentForEntity(entity:Entity, config:Config) -> Result<IComponent>
    {
        return SpriteComponent.build(config:config)
                            .map { $0 as IComponent }
    }


    public func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    {
        let spriteComponent: SpriteComponent? = getTypedComponent(components, .Sprite)
        let nodeComponent:   NodeComponent?   = getTypedComponent(components, .Node)

        if let (sprite, node) = both(spriteComponent, nodeComponent)
        {
            let entityView = EntityView(entityID:entity.uuid, sprite:sprite, node:node)

            // add the `SKSpriteNode` to the `SKNode`
            node.node.addChild(sprite.spriteNode)

            entities.append(entityView)
            return success()
        }
        else { return failure("SpriteSystem could not get NodeComponent for entity (entityID: \(entity.uuid))") }
    }


    public func removeComponentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = entities.find({ $0.entityID == entityID }) {
            let removed = entities.removeAtIndex(index)
            return removed.nodeComponent
        }
        return nil
    }


    public func componentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = entities.find({ $0.entityID == entityID }) {
            return entities[index].nodeComponent
        }
        return nil
    }



    /** Private helper struct to keep references to other components containing data used by this system. */
    private struct EntityView
    {
        let entityID:        Entity.EntityID

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




