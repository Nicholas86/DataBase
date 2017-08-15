//
//  DetailViewController.m
//  LessonDataBase
//
//  Created by lanouhn on 15/8/14.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import "DetailViewController.h"
@interface DetailViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UITextField *nameTF;
@property (retain, nonatomic) IBOutlet UITextField *genderTF;
@property (retain, nonatomic) IBOutlet UITextField *ageTF;
@property (retain, nonatomic) IBOutlet UITextField *phoneTF;

@end
@implementation DetailViewController

//调取相册/摄像头 -- 切换图片
- (IBAction)handleTap:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [sheet showInView:self.view];
    [sheet release];    
}
//配置导航条内容
- (void)configureNavigationBarContent {
    //1.当前界面标题
    self.navigationItem.title = @"详情";
    //2.右边的Edit按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //3.左边的返回按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_navigationBar_back@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBarContent];
    [self configureDetail];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- handle action
- (void)viewWillDisappear:(BOOL)animated {
    //保存当前的Person对象
    self.per.name = self.nameTF.text;
    self.per.gender = self.genderTF.text;
    self.per.age = self.ageTF.text;
    self.per.phone = self.phoneTF.text;
    self.per.image = self.avatarImage.image;
    if ([self.delegate respondsToSelector:@selector(passPerson:)]) {
        [self.delegate passPerson:[Person PersonWithID:self.per.cID name:self.nameTF.text gender:self.genderTF.text age:self.ageTF.text phone:self.phoneTF.text image:self.avatarImage.image]];
    }
}
//返回上一界面
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
 
}

//详情页面赋值操作
- (void)configureDetail{
    self.nameTF.text = self.per.name;
    self.genderTF.text = self.per.gender;
    self.ageTF.text = self.per.age;
    self.phoneTF.text = self.per.phone;
    self.avatarImage.image = self.per.image;
}
- (void)dealloc {
    [_per release];
    [_avatarImage release];
    [_nameTF release];
    [_genderTF release];
    [_ageTF release];
    [_phoneTF release];
    [super dealloc];
}
@end
