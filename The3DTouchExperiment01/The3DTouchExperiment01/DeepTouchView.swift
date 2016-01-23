//
//  DeepTouchView.swift
//  The3DTouchExperiment01
//
//  Created by Paul Jacobs on 1/21/16.
//  Copyright © 2016 Codehearted. All rights reserved.
//

import UIKit

func CGRectCenteredAt(x: CGFloat, y:CGFloat, w: CGFloat, h:CGFloat) -> CGRect {
    return CGRectMake(x-(w*0.5), y-(h*0.5), w, h)
}

class DeepTouchView: UIView {
    var touches : [UITouch] = []
    var points : [CGPoint] = []

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchesMoved(touches, withEvent: event)
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touches = touches.flatMap({ (t:UITouch) -> UITouch in
            return t
        })
        
        self.points = self.touches.map({ (t:UITouch) -> CGPoint in
            return t.locationInView(self)
        })
        
        setNeedsDisplay()

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touches = [];
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 4.0);
        CGContextSetStrokeColorWithColor(context,
            UIColor.blueColor().CGColor);
        self.touches.forEach { (t:UITouch) -> () in
            var forceMultiplier : CGFloat = 1.0
            
            forceMultiplier = t.force
            let stdHeight : CGFloat = 80.0 * forceMultiplier
            let stdWidth : CGFloat = 80.0 * forceMultiplier
           
            let tLoc = t.locationInView(self)
            let rectCenterX : CGFloat = tLoc.x
            let rectCenterY : CGFloat = tLoc.y
            
            let rectangle = CGRectCenteredAt(rectCenterX, y:rectCenterY, w:stdWidth, h:stdHeight);

            CGContextAddEllipseInRect(context, rectangle);
            
            if t.force < 0.5 {
                CGContextAddRect(context, CGRectCenteredAt(rectCenterX, y: rectCenterY, w: 2.0, h: 150.0 * (0.6 / forceMultiplier)))
                
                CGContextAddRect(context, CGRectCenteredAt(rectCenterX, y: rectCenterY, w: 150.0 * (0.6 / forceMultiplier), h: 2.0))
            } else if t.force == t.maximumPossibleForce {
                CGContextFillEllipseInRect(context, rectangle)
            }
            CGContextStrokePath(context);
        }
//        CGContextStrokePath(context);
    }
    
    

}
