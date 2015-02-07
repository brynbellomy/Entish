//
//  PositionSystem.swift
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


/**
    Manages entities that have a position expressed as a `CGPoint`.
*/
public class PositionSystem: ISystem
{
    /** The unique system ID of this system. */
    public let systemID: Systems = Systems.Position

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
    }


    public func willMoveFromController() {
        entityController = nil
    }


    //
    // MARK: - Public API
    //

    public func createComponentForEntity(entity:Entity, config:Config) -> Result<IComponent>
    {
        return PositionComponent.build(config:config)
            .map { $0 as IComponent }
    }


    public func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    {
        let nodeComponent:      PositionComponent?       = getTypedComponent(components, .Node)
        let positionComponent:  PositionComponent?   = getTypedComponent(components, .Position)

        if let (node, position) = both(nodeComponent, positionComponent)
        {
            entities.append <| EntityView(entityID:entity.uuid, position:position)
            return success()
        }
        else { return failure("PositionSystem could not get PositionComponent for entity (entityID: \(entity.uuid))") }
    }


    public func removeComponentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = entities.find({ $0.entityID == entityID }) {
            let removed = entities.removeAtIndex(index)
            return removed.positionComponent
        }
        return nil
    }


    public func componentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = entities.find({ $0.entityID == entityID }) {
            return entities[index].positionComponent
        }
        return nil
    }



    /** Private helper struct to keep references to other components containing data used by this system. */
    private struct EntityView
    {
        let entityID:          Entity.EntityID
        var positionComponent: PositionComponent

        init(entityID eid:Entity.EntityID, position p:PositionComponent) {
            entityID = eid
            positionComponent = p
        }
    }
}

