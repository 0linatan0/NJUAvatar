//
//  NJUBadgeViewController.m
//  NJUAvatar
//
//  Created by tanli on 16/4/18.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import "NJUBadgeViewController.h"
#import "NJUAvatarViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NJUAvatarUserDefaults.h"

@interface NJUBadgeViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *badegImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (assign, nonatomic) CGFloat scale;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property(weak,nonatomic)NJUAvatarViewController *avatarViewController;

@end

@implementation NJUBadgeViewController

- (IBAction)save:(id)sender {
    CGRect frame = _badgeView.frame;
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [_badgeView.layer renderInContext:contextRef];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveImageToPhotosAlbum:resultingImage];
}
- (IBAction)cancel:(id)sender {
//    ViewController *viewController= [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
//    [self presentViewController:viewController animated:YES completion:nil];
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    [self.navigationController popToRootViewControllerAnimated:true];
}

// 保存图片
- (void)saveImageToPhotosAlbum:(UIImage*)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if(error != NULL){
        // 保存图片失败
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        // 保存图片成功
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//        _avatarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NJUAvatarViewController"];
//        [self.navigationController presentViewController:_avatarViewController animated:YES completion:^{
//            [_avatarViewController showAvatar:_avatarImageView.image];
//            
//        }];
        [self.navigationController popToRootViewControllerAnimated:true];
    }
}
- (void)pinch:(id)sender {
    UIPinchGestureRecognizer *gesture = sender;
    _scale = gesture.scale;//得到的是当前手势放大倍数
    NSLog(@"--------%f",_scale);
    //手势改变时
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        //捏合手势中scale属性记录的缩放比例
        _avatarImageView.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
    }
    
    //结束后恢复
    if(gesture.state==UIGestureRecognizerStateEnded)
    {
//        [UIView animateWithDuration:0.5 animations:^{
//            _avatarImageView.transform = CGAffineTransformIdentity;//取消一切形变
//        }];
        _scale = gesture.scale;
    }
}

- (void)rotation:(id)sender {
    UIRotationGestureRecognizer *gesture = sender;
    
    if (gesture.state==UIGestureRecognizerStateChanged)
    {
        _avatarImageView.transform=CGAffineTransformMakeRotation(gesture.rotation);
    }
    
    if(gesture.state==UIGestureRecognizerStateEnded)
    {
        
        [UIView animateWithDuration:1 animations:^{
            _avatarImageView.transform=CGAffineTransformIdentity;//取消形变
        }];
    }
}

- (void)pan:(id)sender {
    UIPanGestureRecognizer *panGesture = sender;
    
    CGPoint movePoint = [panGesture translationInView:self.view];
    
    self.avatarImageView.center = movePoint;
}

- (void)showAvatar:(UIImage *)image withBadge:(UIImage *)badge
{
    self.badegImageView.image = badge;
    self.avatarImageView.image = image;
    [self setHeadPortrait];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setHeadPortrait];
    self.avatarView.backgroundColor = [UIColor whiteColor];
    self.badegImageView.image = [NJUAvatarUserDefaults badge];
    self.avatarImageView.image = [NJUAvatarUserDefaults avatar];
    [self setHeadPortrait];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeadPortrait{
    //  把头像设置成圆形
    self.avatarView.layer.cornerRadius = self.avatarView.frame.size.width/2;
    self.avatarView.layer.masksToBounds = YES;
    //  给头像加一个圆形边框
    self.avatarView.layer.borderWidth = 1.5f;
    self.avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.multipleTouchEnabled = YES;
    
    _saveBtn.layer.cornerRadius = 10;
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    //pinchGesture.delegate = self;
    [_avatarImageView addGestureRecognizer:pinchGesture];
    
    //添加拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_avatarImageView addGestureRecognizer:panGesture];
    
//    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
//    [_avatarImageView addGestureRecognizer:rotationGesture];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
