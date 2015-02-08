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
public class PhysicsSystem: NSObject, ISystem, SKPhysicsContactDelegate
{
    /** A struct containing the `PhysicsSystem`'s subscribable signals.  See the property `signals`. */
    public typealias Signals = PhysicsSystemSignals

    /** The unique system ID of this system. */
    public let systemID: Systems = .Physics

    /** The subscribable signals published by the `PhysicsSystem`.  Subscribe to these to receive notifications when contact events occur in the scene.*/
    public let signals = Signals()

    private var base = SystemBase<PhysicsComponent, EntityView>()

    //
    // MARK: - Lifecycle
    //

    /** The designated initializer. */
    override public init() {
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
        let physicsComponent:   PhysicsComponent?  = getTypedComponent(components, .Physics)
        let nodeComponent:      NodeComponent?     = getTypedComponent(components, .Node)
        let positionComponent:  PositionComponent? = getTypedComponent(components, .Position)

        if let (physicsCmpt, nodeCmpt, positionCmpt) = all(physicsComponent, nodeComponent, positionComponent)
        {
            let entityView = EntityView(entityID:entity.uuid, physics:physicsCmpt, node:nodeCmpt, position:positionCmpt)
            base.addEntityView(entityView)

            // attach the `SKPhysicsBody` to its `SKNode`
            nodeCmpt.node.physicsBody = physicsCmpt.physicsBody

            return success()
        }
        else { return failure("NodeSystem could not get PositionComponent for entity (entityID: \(entity.uuid))") }
    }


    public func removeComponentForEntity(entityID: Entity.EntityID) -> IComponent? {
        return base.removeComponentForEntity(entityID)
    }


    public func componentForEntity(entityID: Entity.EntityID) -> IComponent? {
        return base.componentForEntity(entityID)
    }


    //
    // MARK: - SKPhysicsContactDelegate
    //

    public func didBeginContact(contact:SKPhysicsContact) { signals.didBeginContact.fire(contact) }
    public func didEndContact(contact:SKPhysicsContact)   { signals.didEndContact.fire(contact) }
}


/** Private helper struct to keep references to other components containing data used by this system. */
private struct EntityView: ISystemEntityView
{
    let entityID: Entity.EntityID
    var homeComponent: IComponent { return physicsComponent }

    var physicsComponent:  PhysicsComponent
    var nodeComponent:     NodeComponent
    var positionComponent: PositionComponent

    init(entityID eid:Entity.EntityID, physics phy:PhysicsComponent, node n:NodeComponent, position pos:PositionComponent)
    {
        entityID = eid
        physicsComponent = phy
        nodeComponent = n
        positionComponent = pos
    }
}



