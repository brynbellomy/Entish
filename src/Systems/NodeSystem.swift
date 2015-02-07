//
//  NodeSystem.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 3.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftDataStructures
import LlamaKit
import Funky
import SwiftConfig


/**
    Manages entities that have a corresponding `SKNode`.
 */
public class NodeSystem: ISystem
{
    /** The unique system ID of this system. */
    public let systemID: Systems = Systems.Node

    private var entityController: EntityController?
    private var entities = List<EntityView>()


    //
    // MARK: - Lifecycle
    //

    /** The designated initializer. */
    public init() {
    }


    public func didMoveToController(controller:EntityController) {
        entityController = controller
        controller.signals.update.listen(self, update)
    }


    public func willMoveFromController() {
        entityController?.signals.update.removeListener(self)
        entityController = nil
    }


    public func update(currentTime: NSTimeInterval)
    {
        for entityView in entities
        {
            let node = entityView.nodeComponent.node

            // update the entity's `PositionComponent` when the `SKNode`'s `position` changes
            if entityView.nodeComponent.shouldUpdatePositionComponent
                && node.position != entityView.positionComponent.position
            {
                entityView.positionComponent.position = node.position
            }
        }
    }


    //
    // MARK: - Public API
    //

    public func createComponentForEntity(entity:Entity, config:Config) -> Result<IComponent>
    {
        return NodeComponent.build(config:config)
                            .map { $0 as IComponent }
    }


    public func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    {
        let nodeComponent:      NodeComponent?       = getTypedComponent(components, .Node)
        let positionComponent:  PositionComponent?   = getTypedComponent(components, .Position)

        if let (node, position) = both(nodeComponent, positionComponent)
        {
            entities.append <| EntityView(entityID:entity.uuid, node:node, position:position)
            return success()
        }
        else { return failure("NodeSystem could not get PositionComponent for entity (entityID: \(entity.uuid))") }
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
        let entityID:          Entity.EntityID
        var nodeComponent:     NodeComponent
        var positionComponent: PositionComponent

        init(entityID eid:Entity.EntityID, node n:NodeComponent, position p:PositionComponent) {
            entityID = eid
            nodeComponent = n
            positionComponent = p
        }
    }
}

