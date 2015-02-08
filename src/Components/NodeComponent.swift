//
//  NodeComponent.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 2.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import LlamaKit
import SwiftConfig
import Funky


/**
    A component that provides its `Entity` with an `SKNode`.
 */
public final class NodeComponent: IComponent, IConfigBuildable
{
    /** This function is implemented for `SwiftConfig.IConfigBuildable` conformance. */
    public class func build(#config:Config) -> Result<NodeComponent>
    {
        let shouldUpdatePosition: Bool = config.get("update position") ?? true
        return NodeComponent(entityID: Entity.newID(), shouldUpdatePositionComponent: shouldUpdatePosition) |> success
    }

    /** The unique ID of this component's system. */
    public let systemID: Systems = .Node

    /** The unique ID of the entity to which this component belongs. */
    public var entityID: Entity.EntityID

    /** The `SKNode` that this component provides to its `Entity`. */
    public var node = SKNode()

    /** If `true`, this component will update the `Entity`'s `PositionComponent` any time `node`'s position changes. */
    public var shouldUpdatePositionComponent: Bool

    /** The designated initializer. */
    public init(entityID eid:Entity.EntityID, shouldUpdatePositionComponent update:Bool = true) {
        entityID = eid
        shouldUpdatePositionComponent = update
    }
}

