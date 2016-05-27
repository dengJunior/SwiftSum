//
//  UIImagePickerControllerDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import AssetsLibrary
import MobileCoreServices


class UIImagePickerControllerDemo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonToViewWithTitle("打开照相机") { [unowned self] (button) in
            self.showCamera()
        }
        self.addButtonToViewWithTitle("打开相册") { [unowned self] (button) in
            self.showPhotoLibrary()
        }
        self.addButtonToViewWithTitle("打开照片库") { [unowned self] (button) in
            self.showSavedPhotosAlbum()
        }
    }
    
    func showCamera() {
        let imagePicker = UIImagePickerController()
        
        //指定使用照相机模式,可以指定使用相册／照片库
        imagePicker.sourceType = .Camera
        
        //设置当拍照完或在相册选完照片后，是否跳到编辑模式进行图片剪裁。只有当showsCameraControls属性为true时才有效果
        imagePicker.allowsEditing = true
        //设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
        imagePicker.showsCameraControls = true
        //设置使用后置摄像头，可以使用前置摄像头
        imagePicker.cameraDevice = .Rear
        //设置闪光灯模式
        imagePicker.cameraFlashMode = .Auto
        //捕捉模式指定的是相机是拍摄照片还是视频
        imagePicker.cameraCaptureMode = .Photo
        
        //设置拍摄时屏幕的view的transform属性，可以实现旋转，缩放功能
        // imagepicker.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*45/180);
        // imagepicker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
        //所有含有cameraXXX的属性都必须要sourceType是UIImagePickerControllerSourceTypeCamera时设置才有效果，否则会有异常
        
        //设置相机支持的类型，拍照和录像
        imagePicker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
        
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true) { 
            
        }
        
        /**
         4.自定义相机拍照画面：
         //设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
         imagepicker.showsCameraControls  = NO;
         UIToolbar* tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-55, self.view.frame.size.width, 75)];
         tool.barStyle = UIBarStyleBlackTranslucent;
         UIBarButtonItem* cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCamera)];
         UIBarButtonItem* add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePhoto)];
         [tool setItems:[NSArray arrayWithObjects:cancel,add, nil]];
         //把自定义的view设置到imagepickercontroller的overlay属性中
         imagepicker.cameraOverlayView = tool;
         */
    }
    
    func showPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        
        //指定使用照相机模式,可以指定使用相册／照片库
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true) {
            
        }
    }
    
    func showSavedPhotosAlbum() {
        let imagePicker = UIImagePickerController()
        
        //指定使用照相机模式,可以指定使用相册／照片库
        imagePicker.sourceType = .SavedPhotosAlbum
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true) {
            
        }
    }
}


extension UIImagePickerControllerDemo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //保存照片成功后的回调
    func imageDidFinishSaving(image image: UIImage, error: NSError, contextInfo: UnsafeMutablePointer<Void>) {
        print(#function)
    }
    
    func useImage(image: UIImage) {
        
    }
    
    //当完成内容的选取时会调用
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        defer {
            //模态方式退出uiimagepickercontroller
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        guard let info = editingInfo else {
            //在非Camera时，editingInfo为空，image是选中的图片
            useImage(image)
            return
        }
        
        //通过UIImagePickerControllerMediaType判断返回的是照片还是视频,nil
        let type = info[UIImagePickerControllerMediaType] as? String
        if type != nil {
            
        }
        
        //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
        if picker.sourceType == .Camera {
            //获取照片的原图
            let imageOriginal = info[UIImagePickerControllerOriginalImage] as? UIImage
            //获取图片裁剪的图
            let imageEdited = info[UIImagePickerControllerEditedImage] as? UIImage
            //获取图片裁剪后，剩下的图
            let imageCrop = info[UIImagePickerControllerCropRect] as? UIImage
            //获取媒体的url
            let imageUrl = info[UIImagePickerControllerMediaURL] as? NSURL
            //获取媒体的metadata数据信息
            let imageMetadata = info[UIImagePickerControllerMediaMetadata] as? NSDictionary
            
            if imageOriginal != nil && imageCrop != nil && imageUrl != nil && imageMetadata != nil {
                
            }
            
            //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
            if let edited = imageEdited {
                UIImageWriteToSavedPhotosAlbum(edited, self, #selector(imageDidFinishSaving(image: error: contextInfo:)), nil)
            }
        } else {
            
        }
    }
    
    //当用户取消选取的内容时会调用
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) { 
            
        }
    }
}
