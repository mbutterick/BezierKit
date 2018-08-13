//
//  PathTest.swift
//  BezierKit
//
//  Created by Holmes Futrell on 8/1/18.
//  Copyright © 2018 Holmes Futrell. All rights reserved.
//

import XCTest
import BezierKit

class PathTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitCGPathEmpty() {
        // trivial test of an empty path
        let path = Path(CGMutablePath())
        XCTAssert(path.subpaths.isEmpty)
    }
    
    func testInitCGPathRect() {
        
        // simple test of a rectangle (note that this CGPath uses a moveTo())
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 2))
        let cgPath1 = CGPath(rect: rect, transform: nil)
        let path1 = Path(cgPath1)
        
        let p1 = CGPoint(x: 0.0, y: 0.0)
        let p2 = CGPoint(x: 1.0, y: 0.0)
        let p3 = CGPoint(x: 1.0, y: 2.0)
        let p4 = CGPoint(x: 0.0, y: 2.0)
        
        XCTAssertEqual(path1.subpaths.count, 1)
        XCTAssertEqual(path1.subpaths[0].curves[0] as! LineSegment, LineSegment(p0: p1, p1: p2))
        XCTAssertEqual(path1.subpaths[0].curves[1] as! LineSegment, LineSegment(p0: p2, p1: p3))
        XCTAssertEqual(path1.subpaths[0].curves[2] as! LineSegment, LineSegment(p0: p3, p1: p4))
        XCTAssertEqual(path1.subpaths[0].curves[3] as! LineSegment, LineSegment(p0: p4, p1: p1))
    }
    
    func testInitCGPathEllipse() {
        // test of a ellipse (4 cubic curves)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 2))
        let cgPath2 = CGPath(ellipseIn: rect, transform: nil)
        let path2 = Path(cgPath2)

        let p1 = CGPoint(x: 1.0, y: 1.0)
        let p2 = CGPoint(x: 0.5, y: 2.0)
        let p3 = CGPoint(x: 0.0, y: 1.0)
        let p4 = CGPoint(x: 0.5, y: 0.0)
        
        XCTAssertEqual(path2.subpaths.count, 1)
        XCTAssertEqual(path2.subpaths[0].curves.count, 4)
        XCTAssertEqual(path2.subpaths[0].curves[0].startingPoint, p1)
        XCTAssertEqual(path2.subpaths[0].curves[1].startingPoint, p2)
        XCTAssertEqual(path2.subpaths[0].curves[2].startingPoint, p3)
        XCTAssertEqual(path2.subpaths[0].curves[3].startingPoint, p4)
        XCTAssertEqual(path2.subpaths[0].curves[0].endingPoint, p2)
        XCTAssertEqual(path2.subpaths[0].curves[1].endingPoint, p3)
        XCTAssertEqual(path2.subpaths[0].curves[2].endingPoint, p4)
        XCTAssertEqual(path2.subpaths[0].curves[3].endingPoint, p1)
    }
        
    func testInitCGPathQuads() {
        // test of a rect with some quad curves
        let cgPath3 = CGMutablePath()
        
        let p1 = CGPoint(x: 0.0, y: 1.0)
        let p2 = CGPoint(x: 2.0, y: 1.0)
        let p3 = CGPoint(x: 3.0, y: 0.5)
        let p4 = CGPoint(x: 2.0, y: 0.0)
        let p5 = CGPoint(x: 0.0, y: 0.0)
        let p6 = CGPoint(x: -1.0, y: 0.5)
        
        cgPath3.move(to: p1)
        cgPath3.addLine(to: p2)
        cgPath3.addQuadCurve(to: p4, control: p3)
        cgPath3.addLine(to: p5)
        cgPath3.addQuadCurve(to: p1, control: p6)
        cgPath3.closeSubpath()
        
        let path3 = Path(cgPath3)
        XCTAssertEqual(path3.subpaths.count, 1)
        XCTAssertEqual(path3.subpaths[0].curves.count, 4)
        XCTAssertEqual(path3.subpaths[0].curves[1] as! QuadraticBezierCurve, QuadraticBezierCurve(p0: p2, p1: p3, p2: p4))
    }
    
    func testInitCGPathMultipleSubpaths() {
        // test of 4 line segments where each segment is started with a moveTo
        // this tests multiple subpaths and starting new paths with moveTo instead of closePath
        let cgPath4 = CGMutablePath()
        let p1 = CGPoint(x: 1.0, y: 2.0)
        let p2 = CGPoint(x: 3.0, y: 5.0)
        let p3 = CGPoint(x: -4.0, y: -1.0)
        let p4 = CGPoint(x: 5.0, y: 3.0)
        
        cgPath4.move(to: p1)
        cgPath4.addLine(to: p2)
        cgPath4.move(to: p3)
        cgPath4.addLine(to: p4)
        
        let path4 = Path(cgPath4)
        XCTAssertEqual(path4.subpaths.count, 2)
        XCTAssertEqual(path4.subpaths[0].curves.count, 1)
        XCTAssertEqual(path4.subpaths[1].curves.count, 1)
        XCTAssertEqual(path4.subpaths[0].curves[0] as! LineSegment, LineSegment(p0: p1, p1: p2))
        XCTAssertEqual(path4.subpaths[1].curves[0] as! LineSegment, LineSegment(p0: p3, p1: p4))
    }
    
    func testIntersects() {

        // TODO: improved unit tests ... currently this test is very lax and allows duplicated intersections
        let circleCGPath = CGMutablePath()
        circleCGPath.addEllipse(in: CGRect(origin: CGPoint(x: 2.0, y: 3.0), size: CGSize(width: 2.0, height: 2.0)))
        
        let circlePath = Path(circleCGPath) // a circle centered at (3, 4) with radius 2
        
        let rectangleCGPath = CGMutablePath()
        rectangleCGPath.addRect(CGRect(origin: CGPoint(x: 3.0, y: 4.0), size: CGSize(width: 2.0, height: 2.0)))
        
        let rectanglePath = Path(rectangleCGPath)
        
        let intersections = rectanglePath.intersects(path: circlePath)
        
        XCTAssert(intersections.contains(CGPoint(x: 4.0, y: 4.0)))
        XCTAssert(intersections.contains(CGPoint(x: 3.0, y: 5.0)))
    }
    
    func testPointIsWithinDistanceOfBoundary() {
        
        let circleCGPath = CGMutablePath()
        circleCGPath.addEllipse(in: CGRect(origin: CGPoint(x: -1.0, y: -1.0), size: CGSize(width: 2.0, height: 2.0)))

        let circlePath = Path(circleCGPath) // a circle centered at origin with radius 1
        
        let d = CGFloat(0.1)
        let p1 = CGPoint(x: -3.0, y: 0.0)
        let p2 = CGPoint(x: -0.9, y: 0.9)
        let p3 = CGPoint(x: 0.75, y: 0.75)
        let p4 = CGPoint(x: 0.5, y: 0.5)

        XCTAssertFalse(circlePath.pointIsWithinDistanceOfBoundary(point: p1, distance: d)) // no, path bounding box isn't even within that distance
        XCTAssertFalse(circlePath.pointIsWithinDistanceOfBoundary(point: p2, distance: d)) // no, within bounding box, but no individual curves are within that distance
        XCTAssertTrue(circlePath.pointIsWithinDistanceOfBoundary(point: p3, distance: d))  // yes, one of the curves that makes up the circle is within that distance
        XCTAssertTrue(circlePath.pointIsWithinDistanceOfBoundary(point: p3, distance: CGFloat(10.0)))  // yes, so obviously within that distance implementation should early return yes
        XCTAssertFalse(circlePath.pointIsWithinDistanceOfBoundary(point: p4, distance: d)) // no, we are inside the path but too far from the boundary
        
    }
    
}