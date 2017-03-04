//
//  QuadraticBezierCurve.swift
//  BezierKit
//
//  Created by Holmes Futrell on 3/3/17.
//  Copyright © 2017 Holmes Futrell. All rights reserved.
//

import Foundation

public class QuadraticBezierCurve: BezierCurve {
    
    public var p0: BKPoint {
        return self.points[0]
    }
    public var p1: BKPoint {
        return self.points[1]
    }
    public var p2: BKPoint {
        return self.points[2]
    }
    
    public override init(points: [BKPoint]) {
        precondition(points.count == 3)
        super.init(points: points)
    }
    
    public convenience init(p0: BKPoint, p1: BKPoint, p2: BKPoint) {
        let points = [p0, p1, p2]
        self.init(points: points)
    }

}
