//
//  ExistentialComponent.swift
//  MoarBehaviors
//
//  Created by bryn austin bellomy on 2015 Jan 10.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import Entish
import LlamaKit
import SwiftConfig
import Funky


/**
    Represents a type that has existential traits, such as a name, a certain number of hit points, etc.
 */
public protocol IExistent: class
{
    var existentialComponent: ExistentialComponent { get set }
}


/**
    A component for existential (and semi-existential) traits. 
 */
public final class ExistentialComponent: IComponent, IConfigBuildable
{
    public class func build(#config:Config) -> Result<ExistentialComponent>
    {
        return buildExistentialComponent
                    <|  Entity.newID()
                    <|  config.get("name")
                    <^> config.get("hp") ?± failure("Missing key 'hp' for ExistentialComponent.")
    }

    public typealias HPType = Double

    public let systemID: Systems = .Existential
    public var entityID: Entity.EntityID

    /** The entity's name, if any. */
    public var name: String?

    /** The number of hit points the character can lose before dying. */
    public var HP: HPType

    /** The designated initializer. */
    public init(entityID eid:Entity.EntityID, name n:String?, HP hp:HPType) {
        entityID = eid
        name = n
        HP = hp
    }
}

private func buildExistentialComponent (entityID:Entity.EntityID) (name:String?) (HP:ExistentialComponent.HPType) -> ExistentialComponent {
    return ExistentialComponent(entityID:entityID, name:name, HP:HP)
}


extension ExistentialComponent: Printable, DebugPrintable {
    public var description:      String { return "<ExistentialComponent { name = '\(name)', HP = \(HP) }>" }
    public var debugDescription: String { return description }
}




