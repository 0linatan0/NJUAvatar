#校徽头像
临近毕业季，看到很多学校、学院文化衫，徽章等等周边，就想到可以做一个头像和校徽相结合的小应用，比如这样的
![偶的学校和偶的头像结合](http://7xrh2s.com1.z0.glb.clouddn.com/iosbadge1.JPG)

自己就照着这个想法动手做了第一个小demo
##初稿demo
主要是分四步：

1. 从照片库或者拍照选取照片
2. 选择学校的徽章
3. 可以在校徽中拖动，缩放照片进行调整
4. 生成头像保存

具体过程见如下gif图
![模拟器运行过程](http://7xrh2s.com1.z0.glb.clouddn.com/iosNJUAvatar.gif)

##学习的技术点
###autoresizing
因为这边的界面是用storyBoard制作的，有很多细节的地方需要注意，比如控件的autoresizing属性，
![autoresizing调整](http://upload-images.jianshu.io/upload_images/1290592-72cb00378fb32231.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
需要注意的是**与margin相关的四个值在虚线的时候才有用，width和height在实线的时候才有用**。

###ios弹框
1. 系统弹框
   利用UIAlertController和UIAlertAction构建，在调用照片库和相机时就用到这种弹框，具体代码如下：
   
   ~~~
   //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //......
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
    //......
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
   ~~~
   
2. 第三方框架
利用[MBProgressHUD](https://github.com/jdg/MBProgressHUD)或者[SVProgressHUD](https://github.com/TransitApp/SVProgressHUD
)，SVProgressHUD比较轻量，在保存头像的时候就采用SVProgressHUD,具体代码如下

	~~~
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
  	  if(error != NULL){
        	// 保存图片失败
        	[SVProgressHUD showErrorWithStatus:@"保存失败"];
    	}else{
       	 // 保存图片成功
        	[SVProgressHUD showSuccessWithStatus:@"保存成功"];
        	_viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
        	[self presentViewController:_viewController animated:YES completion:^{
            	[SVProgressHUD dismiss];
        	}];
    	}
}
	~~~

###调用照片库和相机
利用UIImagePickerController，设置其sourceType决定是打开相机还是相册

~~~
//初始化UIImagePickerController
  UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
//获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
//获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
//获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//允许编辑，即放大裁剪
PickerImage.allowsEditing = YES;
//自代理
PickerImage.delegate = self;
//页面跳转
[self presentViewController:PickerImage animated:YES completion:nil];
~~~

   相机、相册中语言是英文的，可以通过在Info.plist中增加Localizations的Item0设值Chinese (simplified)；
   ![](http://7xrh2s.com1.z0.glb.clouddn.com/iosQQ20160420-0.png)
###真机调试
没有苹果大大的开发者账号，找了下有没有其他方法，果然还是网友强[Xcode 7：无需99刀也能在真机上测试App](http://www.cocoachina.com/ios/20150611/12123.html)
如果想上手试试可以直接看[这篇](http://bouk.co/blog/sideload-iphone/)

###缩放和拖动手势
因为头像中支持选中的照片可以拖动和缩放，需要用到UIPinchGestureRecognizer和UIPanGestureRecognizer这两个手势，
具体使用的代码如下

~~~
- (void)pinch:(id)sender {
    UIPinchGestureRecognizer *gesture = sender;
    _scale = gesture.scale;//得到的是当前手势缩放的倍数
    NSLog(@"--------%f",_scale);
    //手势改变时
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        //捏合手势中scale属性记录的缩放比例
        _avatarImageView.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
    }
}
- (void)pan:(id)sender {
    UIPanGestureRecognizer *panGesture = sender;
    CGPoint movePoint = [panGesture translationInView:self.view];
    self.avatarImageView.center = movePoint;
}
~~~

##下一版迭代
1. 需要支持多个校徽，需要仔细考虑选择校徽的交互原型
2. 校徽的形状不固定，比如南大的校徽是个盾牌样子，和其他圆形的不一样，这样就导致生成的头像有些扁，考虑根据校徽的样子进行等比展示
3. 现在照片缩放的圆形区域比较小，两个手指缩放不方便；需要再扩大些，或者支持双击整个图片放大再缩放，有待商榷
4. 图片展示会有卡住的情况，需要优化
5. 目前界面还比较丑，交互方面继续优化
