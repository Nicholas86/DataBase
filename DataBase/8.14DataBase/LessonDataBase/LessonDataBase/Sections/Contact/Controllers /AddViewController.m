//
//  AddViewController.m
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import "AddViewController.h"
#import "UIColor+Additon.h"
@interface AddViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UITextField *nameTF;
@property (retain, nonatomic) IBOutlet UITextField *genderTF;
@property (retain, nonatomic) IBOutlet UITextField *ageTF;
@property (retain, nonatomic) IBOutlet UITextField *phoneTf;

@end

@implementation AddViewController
- (IBAction)handleTap:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [sheet showInView:self.view];
    [sheet release];
    
}
//配置导航条内容
- (void)configureNavigationBarContent {
    //1.当前界面标题
    self.navigationItem.title = @"添加联系人";
    //2.右边的保存按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"doneR@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(handleRight:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    //3.左边的关闭按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clsose@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(handleLeft:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    //4.设置导航条颜色
    self.navigationController.navigationBar.barTintColor = [UIColor lightGreenColor];
    //5.设置导航条渲染颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //6.设置标题颜色
    NSDictionary *attribute = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBarContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- handle action
- (void)handleLeft:(UIBarButtonItem *)item {
    if (!self.nameTF.text.length || !self.phoneTf.text.length) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if ([self.dealegate respondsToSelector:@selector(addPerson:)]) {
        Person *per = [Person PersonWithID:0 name:self.nameTF.text gender:self.genderTF.text age:self.ageTF.text phone:self.phoneTf.text image:self.avatarImage.image];
        [self.dealegate addPerson:per];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleRight:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //创建对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //相片来源:1.photoAlum 2.camera 3.photoLibrary
    //指定相片来源
    switch (buttonIndex) {
        case 0: //拍照
            //判断是否支持相机
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不支持相机拍照,请重新选择" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            break;
        case 1: //从相册选择
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 2:
            return; //取消
        default:
            break;
    }
    //跳转模式
    imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //指定代理
    imagePicker.delegate = self;
    //弹出视图
    [self presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
    
}
#pragma mark -- imagePickerControllerDelegate
//获取图片后触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.avatarImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//取消选择触发
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//AlertViewDelegate中方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            UIActionSheet *sheet = [[UIActionSheet alloc] init];
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
            [sheet showInView:self.view];
            [sheet release];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_avatarImage release];
    [_nameTF release];
    [_genderTF release];
    [_ageTF release];
    [_phoneTf release];
    [super dealloc];
}



@end
