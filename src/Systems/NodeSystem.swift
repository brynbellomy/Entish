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

    private var base = SystemBase<NodeComponent, EntityView>()


    //
    // MARK: - Lifecycle
    //

    /** The designated initializer. */
    public init() {
    }


    public func didMoveToController(controller:EntityController) {
        base.didMoveToController(controller)
        controller.signals.update.listen(self, update)
    }


    public func willMoveFromController() {
        base.entityController?.signals.update.removeListener(self)
        base.willMoveFromController()
    }


    public func update(currentTime: NSTimeInterval)
    {
        for entityView in base.entities
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

    public func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    {
        let nodeComponent:      NodeComponent?       = getTypedComponent(components, .Node)
        let positionComponent:  PositionComponent?   = getTypedComponent(components, .Position)

        if let (nodeCmpt, positionCmpt) = both(nodeComponent, positionComponent)
        {
            // set the node's initial position to the value from the position component
            nodeCmpt.node.position = positionCmpt.position

            base.addEntityView <| EntityView(entityID:entity.uuid, node:nodeCmpt, position:positionCmpt)
            return success()
        }
        else { return failure("NodeSystem could not get some required components for entity (entityID: \(entity.uuid))") }
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
        let entityID:          Entity.EntityID
        var homeComponent:     IComponent { return nodeComponent }

        var nodeComponent:     NodeComponent
        var positionComponent: PositionComponent

        init(entityID eid:Entity.EntityID, node n:NodeComponent, position p:PositionComponent)
        {
            entityID = eid
            nodeComponent = n
            positionComponent = p
        }
    }
}

