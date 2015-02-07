//
//  PhysicsSystem.swift
//  GameObjects
//
//  Created by bryn austin bellomy on 2014 Dec 16.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import Funky
import Signals
import SwiftDataStructures
import LlamaKit
import SwiftConfig
import SwiftBitmask


//
// MARK: - Signals
//
public struct PhysicsSystemSignals
{
    public init() {}
    public let didBeginContact = Signal<SKPhysicsContact>()
    public let didEndContact   = Signal<SKPhysicsContact>()
}

/**
    A system that serves as the `SKPhysicsContactDelegate` for a scene.  It provides
    two signals: `didBeginContact` and `didEndContact`, which fire any time there is a
    physics contact in the scene.  These signals can be filtered to obtain only a
    particular subset of the scene's contact events.
 */
public class PhysicsSystem <T: IBitmaskRepresentable where T: IConfigRepresentable, T.BitmaskRawType == UInt32> : NSObject, ISystem, SKPhysicsContactDelegate
{
    /** A struct containing the `PhysicsSystem`'s subscribable signals.  See the property `signals`. */
    public typealias Signals = PhysicsSystemSignals

    /** The unique system ID of this system. */
    public let systemID: Systems = .Physics

    private var entityController: EntityController?
    private var entities = List<EntityView<T>>()

    /** The subscribable signals published by the `PhysicsSystem`.  Subscribe to these to receive notifications when contact events occur in the scene.*/
    public let signals = Signals()

    //
    // MARK: - Lifecycle
    //

    /** The designated initializer. */
    override public init() {
    }

    public func didMoveToController(controller:EntityController) {
        entityController = controller
    }

    public func willMoveFromController() {
        entityController = nil
    }


    //
    // MARK: - Physics contact callbacks
    //

    public func didBeginContact(contact:SKPhysicsContact) { signals.didBeginContact.fire(contact) }
    public func didEndContact(contact:SKPhysicsContact)   { signals.didEndContact.fire(contact) }


    //
    // MARK: - Public API
    //

    public func createComponentForEntity(entity:Entity, config:Config) -> Result<IComponent>
    {
        return PhysicsComponent<T>.build(config:config)
                                  .map { $0 as IComponent }
    }


    public func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    {
        let physicsComponent:   PhysicsComponent<T>? = getTypedComponent(components, .Physics)
        let nodeComponent:      NodeComponent?       = getTypedComponent(components, .Node)
        let positionComponent:  PositionComponent?   = getTypedComponent(components, .Position)

        if let (physics, node, position) = all(physicsComponent, nodeComponent, positionComponent)
        {
            let entityView = EntityView<T>(entityID:entity.uuid, physics:physics, node:node, position:position)
            entities.append(entityView)

            // attach the `SKPhysicsBody` to its `SKNode`
            node.node.physicsBody = physics.physicsBody

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
}


/** Private helper struct to keep references to other components containing data used by this system. */
private struct EntityView <T: IBitmaskRepresentable where T: IConfigRepresentable, T.BitmaskRawType == UInt32>
{
    let entityID: Entity.EntityID
    var physicsComponent:  PhysicsComponent<T>
    var nodeComponent:     NodeComponent
    var positionComponent: PositionComponent

    init(entityID eid:Entity.EntityID, physics phy:PhysicsComponent<T>, node n:NodeComponent, position pos:PositionComponent)
    {
        entityID = eid
        physicsComponent = phy
        nodeComponent = n
        positionComponent = pos
    }
}



