//
//  PhotoDetailViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import CoreImage
import QuartzCore
import YYKit

private let RetinaToEyeScaleFactor: CGFloat = 0.5
private let FaceBoundsToEyeScaleFactor: CGFloat = 4.0

class PhotoDetailViewController: UIViewController {

    @IBOutlet var photoScrollView: UIScrollView!
    @IBOutlet var photoImageView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = image
        if image.size.height <= photoImageView.bounds.size.height &&
            image.size.width <= photoImageView.bounds.size.width {
            photoImageView.contentMode = .Center
        }
        
        YYGCD.dispatchInGlobalQueue { 
            /*
             faceOverlayImageFromImage 和 fadeInNewImage 2和函数需要花费很多时间，
             如果直接viewDidLoad主线程中执行，会感觉到一个明显的滞后
             这里 使用dispatch_async() 让他们在后台异步执行，
             */
            let overlayImage = self.faceOverlayImageFromImage(self.image)
            YYGCD.dispatchInMainQueue {
                self.fadeInNewImage(overlayImage)
            }
        }
        
        /**
         关于在 dispatch_async 上如何以及何时使用不同的队列类型的快速指导：
         
         1. 自定义串行队列：当你想串行执行后台任务并追踪它时就是一个好选择。这消除了资源争用，因为你知道一次只有一个任务在执行。注意若你需要来自某个方法的数据，你必须内联另一个 Block 来找回它或考虑使用 dispatch_sync。
         2. 主队列（串行）：这是在一个并发队列上完成任务后更新 UI 的共同选择。要这样做，你将在一个 Block 内部编写另一个 Block 。以及，如果你在主队列调用 dispatch_async 到主队列，你能确保这个新任务将在当前方法完成后的某个时间执行。
         3. 并发队列：这是在后台执行非 UI 工作的共同选择。
         */
    }

}

// MARK: - UIScrollViewDelegate

extension PhotoDetailViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}

// MARK: - Private Methods

private extension PhotoDetailViewController {
    // MARK: - 图片人脸检测，并生成了一个新的曲棍球眼睛图像。
    func faceOverlayImageFromImage(image: UIImage) -> UIImage {
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        // Get features from the image
        let newImage = CIImage(CGImage: image.CGImage!)
        let features = detector.featuresInImage(newImage) as! [CIFaceFeature]
        
        UIGraphicsBeginImageContext(image.size)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        // Draws this in the upper left coordinate system
        image.drawInRect(imageRect, blendMode: CGBlendMode.Normal, alpha: 1.0)
        
        let context = UIGraphicsGetCurrentContext()
        for faceFeature in features {
            let faceRect = faceFeature.bounds
            CGContextSaveGState(context)
            
            // CI and CG work in different coordinate systems, we should translate to
            // the correct one so we don't get mixed up when calculating the face position.
            CGContextTranslateCTM(context, 0.0, imageRect.size.height)
            CGContextScaleCTM(context, 1.0, -1.0)
            
            if faceFeature.hasLeftEyePosition {
                let leftEyePosition = faceFeature.leftEyePosition
                let eyeWidth = faceRect.size.width / FaceBoundsToEyeScaleFactor
                let eyeHeight = faceRect.size.height / FaceBoundsToEyeScaleFactor
                let eyeRect = CGRect(x: leftEyePosition.x - eyeWidth / 2.0,
                                     y: leftEyePosition.y - eyeHeight / 2.0,
                                     width: eyeWidth,
                                     height: eyeHeight)
                drawEyeBallForFrame(eyeRect)
            }
            
            if faceFeature.hasRightEyePosition {
                let leftEyePosition = faceFeature.rightEyePosition
                let eyeWidth = faceRect.size.width / FaceBoundsToEyeScaleFactor
                let eyeHeight = faceRect.size.height / FaceBoundsToEyeScaleFactor
                let eyeRect = CGRect(x: leftEyePosition.x - eyeWidth / 2.0,
                                     y: leftEyePosition.y - eyeHeight / 2.0,
                                     width: eyeWidth,
                                     height: eyeHeight)
                drawEyeBallForFrame(eyeRect)
            }
            
            CGContextRestoreGState(context);
        }
        
        let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return overlayImage
    }
    
    func faceRotationInRadians(leftEyePoint startPoint: CGPoint, rightEyePoint endPoint: CGPoint) -> CGFloat {
        let deltaX = endPoint.x - startPoint.x
        let deltaY = endPoint.y - startPoint.y
        let angleInRadians = CGFloat(atan2f(Float(deltaY), Float(deltaX)))
        
        return angleInRadians;
    }
    
    func drawEyeBallForFrame(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(context, rect)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillPath(context)
        
        var x: CGFloat
        var y: CGFloat
        var eyeSizeWidth: CGFloat
        var eyeSizeHeight: CGFloat
        eyeSizeWidth = rect.size.width * RetinaToEyeScaleFactor
        eyeSizeHeight = rect.size.height * RetinaToEyeScaleFactor
        
        x = CGFloat(arc4random_uniform(UInt32(rect.size.width - eyeSizeWidth)))
        y = CGFloat(arc4random_uniform(UInt32(rect.size.height - eyeSizeHeight)))
        x += rect.origin.x
        y += rect.origin.y
        
        let eyeSize = min(eyeSizeWidth, eyeSizeHeight)
        let eyeBallRect = CGRect(x: x, y: y, width: eyeSize, height: eyeSize)
        CGContextAddEllipseInRect(context, eyeBallRect)
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextFillPath(context)
    }
    
    // MARK: - 更新 UI ，它执行一个淡入过程切换到新的曲棍球眼睛图像。
    func fadeInNewImage(newImage: UIImage) {
        let tmpImageView = UIImageView(image: newImage)
        tmpImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tmpImageView.contentMode = photoImageView.contentMode
        tmpImageView.frame = photoImageView.bounds
        tmpImageView.alpha = 0.0
        photoImageView.addSubview(tmpImageView)
        
        UIView.animateWithDuration(0.75, animations: {
            tmpImageView.alpha = 1.0
            }, completion: {
                finished in
                self.photoImageView.image = newImage
                tmpImageView.removeFromSuperview()
        })
    }
}
