//
//  CompanyViewController.m
//  中铁协同平台
//
//  Created by gu on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CompanyViewController.h"
#import "CompanyNextTableViewController.h"
@interface CompanyViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *companyRegistCode;
@property (strong, nonatomic) IBOutlet UITextField *companyName;
@property (strong, nonatomic) IBOutlet UITextField *companyMemo;
@property (strong, nonatomic) IBOutlet UIImageView *companyImageView;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_bgView strokeViewRatio:4 header:NO footer:NO];
}

- (void)addRightItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(companyNext)];
    self.parentViewController.navigationItem.rightBarButtonItem = item;
}

- (IBAction)updateImage:(UIButton *)sender {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithIndex:0];
    }];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithIndex:1];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alter addAction:photo];
    [alter addAction:takePhoto];
    [alter addAction:cancel];
    [self presentViewController:alter animated:YES completion:nil];
}


- (void)companyNext
{
    UIStoryboard *loginStoryBoard = [UIStoryboard  storyboardWithName:@"Login" bundle:nil];
    CompanyNextTableViewController *vc = [loginStoryBoard instantiateViewControllerWithIdentifier:@"CompanyNextTableViewControllerSBID"];
    [self.navigationController pushViewController:vc animated:YES];
}


//#pragma mark - 选取照片和拍照
-(void)takePhotoWithIndex:(NSInteger )index
{
    
    // 判断设备是否支持相册
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"设备不支持访问相册");
        
        return ;
    }
    //判断设备是否支持照相机
    
    UIImagePickerController * mipc = [[UIImagePickerController alloc] init];
    switch (index) {
        case 0:
            mipc.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        case 1:
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                NSLog(@"设备不支持访问照相机");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                                message:@"设备不支持访问照相机"
                                                               delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            mipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
            break;
        case 2:
            break;
        default:
            break;
    }
    mipc.delegate = self;//委托
    mipc.allowsEditing = NO;//是否可编辑照片
    mipc.mediaTypes=[NSArray arrayWithObjects:@"public.image",nil];
    // 设置可用媒体类型
    [self presentViewController:mipc animated:YES completion:^(void){
        //        NSLog(@"1");
        //        NSLog(@"%@",NSHomeDirectory());
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage] == nil?info [UIImagePickerControllerOriginalImage]:info[UIImagePickerControllerEditedImage];
    _companyImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
