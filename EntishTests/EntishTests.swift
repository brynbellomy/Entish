//
//  EntishTests.swift
//  EntishTests
//
//  Created by bryn austin bellomy on 2015 Jan 5.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import Entish
import SwiftConfig
import SwiftBitmask


class EntishTests: XCTestCase
{
    func testBuildPositionComponent() {
        let config = Config()
        let position = PositionComponent.build(config: config)
        XCTAssertTrue(position.isSuccess())
        XCTAssert(position.value()?.position == CGPointZero)
    }

    func testExample()
    {
        let dict = [
            "entity templates": [
                [
                    "name": "TestEntity",
                    "components": [
                        ["system": "position"],
                        ["system": "node"],
                    ],
                ]
            ]
        ]
        let config = Config(dictionary:dict)
        var factory = EntityFactory()
        factory.configure(config)
        let maybeEnt = factory.createEntityFromTemplate("TestEntity")
        if let err = maybeEnt.error() {
            NSLog("EntityFactory error: \(err.localizedDescription)")
        }
        XCTAssertTrue(maybeEnt.isSuccess())

        if let (entity, components) = maybeEnt.value() {
            XCTAssertEqual(entity.componentBitmask, Systems.Position | .Node)
        }
    }
}

