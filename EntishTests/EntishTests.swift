//
//  EntishTests.swift
//  EntishTests
//
//  Created by bryn austin bellomy on 2015 Jan 5.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import LlamaKit
import Funky
import Entish
import SwiftConfig
import SwiftBitmask


class EntishTests: XCTestCase
{
    var config: Config?

    override func setUp() {
        super.setUp()
        config = Config(yamlFilename: "entities", bundle: NSBundle(forClass: EntishTests.self))
    }

//    func testPositionComponentBuild() {
//        let config = Config()
//        let position = PositionComponent.build(config: config)
//        XCTAssertTrue(position.isSuccess())
//        XCTAssert(position.value()?.position == CGPointZero)
//    }

    func testEntityFactory()
    {
        var factory = EntityFactory()
        factory.configure(config!)

        let maybeEnt = factory.createEntityFromTemplate("Hero")
        if let err = maybeEnt.error() { NSLog("EntityFactory error: \(err.localizedDescription)") }
        XCTAssertTrue(maybeEnt.isSuccess())

        if let (entity, components) = maybeEnt.value() {
            XCTAssertEqual(entity.componentBitmask, Systems.Position | .Node)
        }
    }


    func testEntityController()
    {
        var entcon = EntityController()
        entcon.configure(config!)

        entcon.registerSystem(PositionSystem())
        entcon.registerSystem(NodeSystem())

        entcon.entityFactory.createComponentFromConfig = { config in
            let system: Systems = config.get("system")!

            switch system {
                case .Node:         return NodeComponent.build(config: config).map { $0 as IComponent }
                case .Sprite:       return SpriteComponent.build(config: config).map { $0 as IComponent }
                case .Position:     return PositionComponent.build(config: config).map { $0 as IComponent }
                case .Existential:     return ExistentialComponent.build(config: config).map { $0 as IComponent }
//                case .Physics:      return PhysicsComponent.build(config: config).map { $0 as IComponent }
//                case .Animation:    return AnimationComponent.build(config: config).map { $0 as IComponent }
//                case .Steering:
                default:
                    return failure("Unknown system type '\(system)'")
            }
        }

        let maybeEnt = entcon.createEntity(template: "Hero")
        if let err = maybeEnt.error() { NSLog("L'errore: \(err.localizedDescription)") }
        XCTAssertTrue(maybeEnt.isSuccess())
    }
}

