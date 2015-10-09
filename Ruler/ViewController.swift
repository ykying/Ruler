//
//  ViewController.swift
//  Ruler
//
//  Created by King.Ying on 10/9/15.
//  Copyright © 2015 King. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RulerScrollViewDelegate {
    
    @IBOutlet weak var rulerScrollViewV: RulerScrollView!
    @IBOutlet weak var rulerScrollViewH: RulerScrollView!
    @IBOutlet weak var lblCurrentVValue: UILabel!
    @IBOutlet weak var lblCurrentHValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rulerScrollViewV.initRuler(self, imageNameForUnit: "unit", rulerAutoAlignToCloseInt: true)
        rulerScrollViewH.initRuler(self, imageNameForUnit: "unith", rulerDirection: RulerDirection.Horizontal, rulerTotalUnitCount: 100, rulerUnitStartNumber: 50, rulerUnitString: "kg")
        
        lblCurrentVValue.text = "100 cm"
        lblCurrentHValue.text = "50 kg"
        rulerScrollViewV.showsHorizontalScrollIndicator = false
        rulerScrollViewV.showsVerticalScrollIndicator = false
        rulerScrollViewH.showsHorizontalScrollIndicator = false
        rulerScrollViewH.showsVerticalScrollIndicator = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func rulerScrollViewValueChanged(rulerScrollView: RulerScrollView, value: CGFloat) {
        if rulerScrollView == rulerScrollViewV{
            lblCurrentVValue.text = String(format: "%.3f cm", value)
        }
        if rulerScrollView == rulerScrollViewH{
            lblCurrentHValue.text = String(format: "%.3f kg", value)
        }
    }
}

