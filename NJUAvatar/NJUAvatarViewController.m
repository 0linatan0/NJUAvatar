//
//  NJUAvatarViewController.m
//  NJUAvatar
//
//  Created by tanli on 16/4/19.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import "NJUAvatarViewController.h"
#import "NJUBadgeViewController.h"
#import "NJUBadgeTableViewController.h"
#import "NJUAvatarUserDefaults.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface NJUAvatarViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) UIImage *avatar;
@property (weak, nonatomic) IBOutlet UIButton *reChooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *njuBadgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *seuBadgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *tsinghuaBtn;
@property (weak, nonatomic) IBOutlet UIButton *pekingBtn;
@property (weak, nonatomic) IBOutlet UIButton *nustBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) NJUBadgeViewController *badgeViewController;
@end

@implementation NJUAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _avatar = [NJUAvatarUserDefaults avatar];
    if (!_avatar) {
        _avatar = [UIImage imageNamed:@"avatar"];
        [NJUAvatarUserDefaults saveAvatar:_avatar];
    }
    _avatarImageView.image = _avatar;
    [SVProgressHUD dismiss];
}

- (void)viewDidLayoutSubviews
{
    [_scrollView setContentSize:CGSizeMake(630, 100)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAvatar:(UIImage *)image
{
    _avatar = image;
    _avatarImageView.image = _avatar;
}

- (IBAction)rechooseClick:(id)sender {
    [self alterPic];
}

- (IBAction)njuBadgeClick:(id)sender {
    [self badgeClick:sender];
}
- (IBAction)sueBadgeClick:(id)sender {
    [self badgeClick:sender];
}

- (IBAction)TsinghuaClick:(id)sender {
    [self badgeClick:sender];
}

- (IBAction)pekingClick:(id)sender {
    [self badgeClick:sender];
}

- (IBAction)nustClick:(id)sender {
    [self badgeClick:sender];
}
- (IBAction)moreClick:(id)sender {
    NJUBadgeTableViewController *badgeTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"badgeTableViewController"];
    [self.navigationController pushViewController:badgeTableViewController animated:YES];
//    [self presentViewController:badgeTableViewController animated:YES completion:nil];
}

- (void)badgeClick:(id)sender
{
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIButton *badgeClick = sender;
    _badgeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"badgeViewController"];
//    [self presentViewController:_badgeViewController animated:YES completion:^{
//        [_badgeViewController showAvatar:_avatar withBadge:badgeClick.currentBackgroundImage];
//    }];
    [NJUAvatarUserDefaults saveBadge:badgeClick.currentBackgroundImage];
    [self.navigationController pushViewController:_badgeViewController animated:YES];
    
}

-(void)alterPic{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self showAvatar:newPhoto];
    //存储照片
    [NJUAvatarUserDefaults saveAvatar:newPhoto];
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // 在控制台打印Segue的信息
//    NSLog(@"Source Controller = %@", [segue sourceViewController]);
//    NSLog(@"Destination Controller = %@", [segue destinationViewController]);
//    NSLog(@"Segue Identifier = %@", [segue identifier]);
//    
//    // 判断是哪个segue被执行了，并执行相应的操作
//    if ([[segue identifier] isEqualToString:@"badgeListSegue"]) {
//        NJUBadgeTableViewController *badgeTableViewController = [segue destinationViewController];
//        badgeTableViewController.avatarImageName = @"hha";
//    }
//}


@end
