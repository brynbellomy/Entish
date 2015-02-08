//
//  ComponentTests.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 8.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import Funky
import Entish
import SwiftConfig
import SwiftBitmask

@objc(ComponentTests)
class ComponentTests: XCTestCase
{
    var config: Config?
    var componentConfigs: [String: Config]?

    override func setUp()
    {
        super.setUp()

        config = Config(yamlFilename: "test-components", bundle: NSBundle(forClass:ComponentTests.self))
        componentConfigs = config?.get("components")
    }
    
    override func tearDown() {
        super.tearDown()
    }


    func testExistentialComponent()
    {
        let existentialConfig = (componentConfigs?["existential"])!
        let maybeComponent    = ExistentialComponent.build(config:existentialConfig)

        XCTAssertTrue(maybeComponent.isSuccess())

        let component = maybeComponent.value()!
        XCTAssertEqual(component.HP, 112)
        XCTAssertEqual(component.name!, "samus")
    }


    func testPositionComponent()
    {
        let positionConfig = componentConfigs?["position"]
        XCTAssert(positionConfig != nil)

        let maybeComponent = PositionComponent.build(config:positionConfig!)

        if let err = maybeComponent.error() { NSLog("Error: \(err.localizedDescription)") }
        XCTAssertTrue(maybeComponent.isSuccess())

        let component = maybeComponent.value()!
        XCTAssertTrue(component.position == CGPoint(x:42.5, y:-67.1))
    }

    func testNodeComponent()
    {
        let nodeConfig = componentConfigs?["node"]
        XCTAssert(nodeConfig != nil)

        let maybeComponent = NodeComponent.build(config:nodeConfig!)

        if let err = maybeComponent.error() { NSLog("Error: \(err.localizedDescription)") }
        XCTAssertTrue(maybeComponent.isSuccess())

        let component = maybeComponent.value()!
        XCTAssertTrue(component.shouldUpdatePositionComponent == false)
    }

    func testSpriteComponent()
    {
        let spriteConfig = componentConfigs?["sprite"]
        XCTAssert(spriteConfig != nil)

        let maybeComponent = SpriteComponent.build(config:spriteConfig!)

        if let err = maybeComponent.error() { NSLog("Error: \(err.localizedDescription)") }
        XCTAssertTrue(maybeComponent.isSuccess())

        maybeComponent.value()
    }
}



