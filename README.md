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

#校徽头像version2
在上一版demo实现可以选取照片库图片，可以对照片放大、缩小、拖动完成一个校徽头像的基础上，考虑实际应用场景，对交互过程进行修改，实现version2。
##多个校徽展示
考虑到实际场景中，会有很多的校徽需要展示给用户，鉴于用户不仅仅选择自己学校的，他也会有兴趣将自己的头像放到其他学校的校徽上，所以需要支持用户可以浏览所有学校校徽并可以多次尝试。

1. 启发1：美拍和Faceu中对图片修饰时，会在图片的的下方展示一系列素材，用户通过橫滑可以浏览到所有素材；这种交互简单直观，但是对于校徽展示来说，有两个弊端，一个是校徽比较抽象，如果看不清上面的字母，光靠标志来辨认还是有难度的，可见不能所得；另一个是校徽会有很多，如果是通过橫滑浏览，用户需要滑动多次，会引起疲劳。
2. 启发2：通过列表展示所有校徽，起初考虑选用collectionView网格状式作为展示，但基于第一点的分析，校徽不容易辨认，所以换成文字作为主要，图片作为辅助利用tableView作为展示，为了便于查找，采用带索引展示。

##运行结果展示
![运行结果](http://7xrh2s.com1.z0.glb.clouddn.com/iosNJUAvatar_Version2.gif)

##学习的技术点
###scrollView
在底栏的校徽展示采用scrollView实现，[理解iOS开发中的scrollView](http://mobile.51cto.com/hot-430409.htm)这篇文章中解释scrollView工作原理，每个视图都有一个bounds和frame，视图的frame决定了自己在父视图中绘制的位置，frame的origin表明了视图左上角相对父视图左上角的偏移量，bounds表示该视图在其自身坐标系中的位置和大小。如下图:
![bounds&frame](http://7xrh2s.com1.z0.glb.clouddn.com/iosbounds%26frame.png)
scrollView的属性contentOffset决定了当前scrollView显示内容的范围，即是当前scrollView的左上角的显示位置坐标，相当于它改变scrollView.bounds的origin,使得scrollView基于自身的坐标系发生了位置偏移，其代码类似于

~~~
- (void)setContentOffset: (CGPoint)contentOffset
 {
    _contentOffset = contentOffset;
    CGRect bounds = self.bounds;
    bounds.origin = contentOffset;
    self.bounds = bounds;
 }
~~~
scrollView的属性contentSize决定了scrollView显示内容的尺寸范围，在contentSize的宽度或者长度大于bounds的时候，才能实现滚动效果。content offset的最大值是contentSize和scrollView size的差。需要在代码中实现

~~~
[_scrollView setContentSize:CGSizeMake(630, 100)];
~~~
scrollView的contentInset属性可以改变contentOffset的最大和最小值，这样便可以滚动出可滚动区域。它的类型为UIEdgeInsets，包含四个值： {top，left，bottom，right}。具体可以看[scrollView实现](http://www.jianshu.com/p/bd0023af0c9a)

###tableView中实现首字母索引
这边是用到了UILocalizedIndexedCollation进行首字母排序，借鉴苹果官方例子[Apple UITableView sampleCode](https://developer.apple.com/library/ios/samplecode/TableViewSuite/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007318-Intro-DontLinkElementID_2)中的第三个simpleIndexedTableView
UILocalizedIndexedCollation的分组排序是建立在对对象的操作上，在这个项目中，建立校徽对象

~~~
@interface NJUBadge : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *imageName;
- (instancetype)initWithName:(NSString *)name image:(NSString*)imageName;
@end
~~~
校徽对象数组是放在plist中
![badgePlist](http://7xrh2s.com1.z0.glb.clouddn.com/iosbadgesPlist.png)

~~~
//获取plist中数据
NSBundle *bundle = [NSBundle mainBundle];
NSString *plistpath = [bundle pathForResource:@"badges" ofType:@"plist"];
_badgeList = [[NSArray alloc]initWithContentsOfFile:plistpath];
~~~
将UILocalizedIndexedCollation进行初始化

~~~
//会根据不同国家的语言初始化出不同的结果如中文和英文的得到的就是A~Z和#
UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
~~~

将数据按照首字母分类放入各个数组中

~~~
for (NSInteger index = 0; index < [[_collation sectionTitles] count]; index++)
{
   NSMutableArray *array = [[NSMutableArray alloc] init];
   [_newSectionsArray addObject:array];
}
for (NSInteger index = 0; index < [_badgeList count]; index++)
{
    NSDictionary *badgeItemDic = _badgeList[index];
    NSString *badgeName = [badgeItemDic objectForKey:@"name"];
    NSString *badgeImageName = [badgeItemDic objectForKey:@"image"];
    NJUBadge *badgeItem = [[NJUBadge alloc]initWithName:badgeName image:badgeImageName]; 
    NSInteger sectionNumber = [_collation sectionForObject:badgeItem collationStringSelector:@selector(name)];
    [_newSectionsArray[sectionNumber] addObject:badgeItem];
}
~~~

对每个数组中数据进行排序

~~~
for (NSInteger index = 0; index < [[_collation sectionTitles] count]; index++) 
{
    NSMutableArray *badgeArrayForSection = _newSectionsArray[index];
    NSArray *sortedPersonArrayForSection = [_collation sortedArrayFromArray:badgeArrayForSection collationStringSelector:@selector(name)];
    _newSectionsArray[index] = sortedPersonArrayForSection;
}
~~~
从collation中获取section的titles和indexTitles

~~~
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _collation.sectionTitles[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _collation.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_collation sectionForSectionIndexTitleAtIndex:index];
}
~~~

##参考
[理解iOS开发中的Scroll View](http://mobile.51cto.com/hot-430409.htm)

[理解UIScrollView](http://blog.jobbole.com/70143/)

[Apple NavigationBar sampleCode](https://developer.apple.com/library/ios/samplecode/NavBar/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007418)

[Apple UITableView sampleCode](https://developer.apple.com/library/ios/samplecode/TableViewSuite/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007318-Intro-DontLinkElementID_2)

[UI设计](http://ui4app.com/category)
