//
//  RulerScrollView.swift
//  VerticalRuler
//
//  Created by King.Ying on 10/9/15.
//  Copyright © 2015 King. All rights reserved.
//

import UIKit

enum RulerDirection:Int{
    case Horizontal = 0
    case Vertical = 1
}

protocol RulerScrollViewDelegate{
    func rulerScrollViewValueChanged(rulerScrollView: RulerScrollView, value: CGFloat)
}

class RulerScrollView: UIScrollView, UIScrollViewDelegate {
    //Options
    private var rulerScrollViewDelegate: RulerScrollViewDelegate? = nil
    private var direction: RulerDirection = RulerDirection.Vertical
    private var totalUnitCount: Int = 100
    private var unitStartNumber: Int = 100
    private var imageNameForOneUnit: String = "unit"
    private var unitString: String = "CM"
    private var autoAlignToCloseInt: Bool = false
    //Options
    
    
    private var unitEdge: CGFloat = 0
    private var UIInited = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initRuler(rulerDelegate: RulerScrollViewDelegate, imageNameForUnit: String, rulerDirection: RulerDirection=RulerDirection.Vertical, rulerTotalUnitCount: Int=100, rulerUnitStartNumber: Int=100, rulerUnitString: String="cm", rulerAutoAlignToCloseInt: Bool = false){
        
        rulerScrollViewDelegate = rulerDelegate
        direction = rulerDirection
        totalUnitCount = rulerTotalUnitCount
        unitStartNumber = rulerUnitStartNumber
        unitString = rulerUnitString
        imageNameForOneUnit = imageNameForUnit
        autoAlignToCloseInt = rulerAutoAlignToCloseInt
        
    }
    
    private func initUI(){
        if UIInited {
            return
        }
        UIInited = true
        
        self.delegate = self
        
        let labelWidth: CGFloat = 50
        let labelHeight: CGFloat = 20
        var lblCenterPoint: CGFloat = 0
        var startPoint: CGFloat = 0
        
        if direction == .Vertical { // Edge as width
            unitEdge = CGRectGetWidth(self.frame)
            lblCenterPoint = unitEdge - labelWidth/2.0
            startPoint = CGRectGetHeight(self.bounds)/2.0
        } else { // Edge as Height
            unitEdge = CGRectGetHeight(self.frame)
            lblCenterPoint = unitEdge - labelHeight/2.0
            startPoint = CGRectGetWidth(self.bounds)/2.0
        }
        
        
        if let _ = UIImage(named: imageNameForOneUnit){ //Check Image Exists
            for (var i=0; i<totalUnitCount; i++){
                if let img = UIImage(named: imageNameForOneUnit){ //Build Image & Label Array
                    let imgv = UIImageView(image: img)
                    let lbl = UILabel(frame: CGRectMake(0, 0, labelWidth, labelHeight))
                    lbl.backgroundColor = UIColor.clearColor()
                    lbl.textAlignment = NSTextAlignment.Center
                    lbl.font = UIFont.systemFontOfSize(12)
                    lbl.adjustsFontSizeToFitWidth = true
                    lbl.minimumScaleFactor = 0.5
                    lbl.textColor = UIColor.blackColor()
                    
                    let coor = CGFloat(i) * unitEdge + startPoint
                    if direction == .Vertical {
                        imgv.frame = CGRectMake(0, coor, unitEdge, unitEdge)
                        lbl.center = CGPointMake(lblCenterPoint, coor)
                    } else {
                        imgv.frame = CGRectMake(coor, 0, unitEdge, unitEdge)
                        lbl.center = CGPointMake(coor, lblCenterPoint)
                    }
                    lbl.text = String(format: "%d %@", (unitStartNumber+i), unitString)
                    
                    self.addSubview(imgv)
                    self.addSubview(lbl)
                    
                }
            }
            if direction == .Vertical {
                self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGFloat(totalUnitCount) * unitEdge + CGRectGetHeight(self.frame))
            } else {
                self.contentSize = CGSizeMake(CGFloat(totalUnitCount) * unitEdge + CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
            }
            
        }
        
    }
    
    func moveToCloseInt() {
        if !autoAlignToCloseInt {
            return
        }
        var targetPixel: CGFloat = 0.0
        if direction == .Vertical {
            targetPixel = CGFloat(roundf(Float(self.contentOffset.y / unitEdge))) * unitEdge
            self.setContentOffset(CGPointMake(self.contentOffset.x, targetPixel), animated: true)
            
        } else {
            targetPixel = CGFloat(roundf(Float(self.contentOffset.x / unitEdge))) * unitEdge
            self.setContentOffset(CGPointMake(targetPixel, self.contentOffset.y), animated: true)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initUI()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var value: CGFloat = 0.0
        if direction == .Vertical {
            value = self.contentOffset.y / unitEdge
        } else {
            value = self.contentOffset.x / unitEdge
        }
        value += CGFloat(unitStartNumber)
        if let rulerDelegate = rulerScrollViewDelegate {
            rulerDelegate.rulerScrollViewValueChanged(self, value: value)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.moveToCloseInt()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.moveToCloseInt()
    }
}
