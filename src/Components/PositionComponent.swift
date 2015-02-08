//
//  PositionComponent.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 3.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftConfig
import LlamaKit
import Funky
import BrynSwift


/**
    A component containing a position as a `CGPoint`.
 */
public final class PositionComponent: IComponent, IConfigBuildable
{
    /** This function is implemented for `SwiftConfig.IConfigBuildable` conformance. */
    public class func build(#config:Config) -> Result<PositionComponent>
    {
        if let point: CGPoint = config.get("position") {
            return success(PositionComponent(entityID: Entity.newID(), position:point))
        }
        return failure("Could not get value of config key 'position' as a CGPoint.")
    }

    /** The unique ID of this component's system. */
    public let systemID: Systems = .Position

    /** The unique ID of the entity to which this component belongs. */
    public var entityID: Entity.EntityID

    /** The `CGPoint` that this component provides to its `Entity`. */
    public var position: CGPoint

    /** The designated initializer. */
    public init(entityID eid:Entity.EntityID, position p:CGPoint = CGPointZero)
    {
        entityID = eid
        position = p
    }
}

extension PositionComponent: Printable, DebugPrintable {
    public var description:      String { return "<PositionComponent { position = \(position.bk_shortDescription) }>" }
    public var debugDescription: String { return description }
}



