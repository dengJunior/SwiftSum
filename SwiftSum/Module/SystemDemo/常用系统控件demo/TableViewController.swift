//
//  TableViewController.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class TableViewController: UITableViewController {
    
    let blendModes: [CGBlendMode] = [
        /* Available in Mac OS X 10.4 & later. */
        .Normal,
        .Multiply,
        .Screen,
        .Overlay,
        .Darken,
        .Lighten,
        .ColorDodge,
        .ColorBurn,
        .SoftLight,
        .HardLight,
        .Difference,
        .Exclusion,
        .Hue,
        .Saturation,
        .Color,
        .Luminosity,
        
        /* Available in Mac OS X 10.5 & later. R, S, and D are, respectively,
         premultiplied result, source, and destination colors with alpha; Ra,
         Sa, and Da are the alpha components of these colors.
         
         The Porter-Duff "source over" mode is called `kCGBlendModeNormal':
         R = S + D*(1 - Sa)
         
         Note that the Porter-Duff "XOR" mode is only titularly related to the
         classical bitmap XOR operation (which is unsupported by
         CoreGraphics). */
        .Clear /* R = 0 */,
        .Copy /* R = S */,
        .SourceIn /* R = S*Da */,
        .SourceOut /* R = S*(1 - Da) */,
        .SourceAtop /* R = S*Da + D*(1 - Sa) */,
        .DestinationOver /* R = S*(1 - Da) + D */,
        .DestinationIn /* R = D*Sa */,
        .DestinationOut /* R = D*(1 - Sa) */,
        .DestinationAtop /* R = S*(1 - Da) + D*Sa */,
        .XOR /* R = S*(1 - Da) + D*(1 - Sa) */,
        .PlusDarker /* R = MAX(0, (1 - D) + (1 - S)) */,
        .PlusLighter /* R = MIN(1, S + D) */
    ]
    
    let alphaImage = UIImage(named: "alphaImage.png")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "BlendModeCell", bundle: nil), forCellReuseIdentifier: "BlendModeCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blendModes.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BlendModeCell", forIndexPath: indexPath) as? BlendModeCell
        cell?.imageV?.image = alphaImage.tint(UIColor.orangeColor(), blendMode: blendModes[indexPath.row])
        cell?.title?.text = "blendMode = \(blendModes[indexPath.row].rawValue)"
        
        return cell!
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
