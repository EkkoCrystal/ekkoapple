//
//  ARScanViewController.m
//  ekkoTest
//
//  Created by ekko on 2018/5/14.
//  Copyright © 2018年 ekkoProduct. All rights reserved.
//

#import "ARScanViewController.h"
//3D游戏框架
#import <SceneKit/SceneKit.h>
//AR
#import <ARKit/ARKit.h>


/**
 1.相机捕捉现实世界图像.由ARKit来实现.
 2.在图像中显示虚拟3D模型,由SceneKit来实现.
 */
API_AVAILABLE(ios(11.0))

@interface ARScanViewController ()
/**
 1.<ARKit>框架中中显示3D虚拟增强现实的视图ARSCNView继承于<SceneKit>框架中的SCNView,而SCNView又继承于<UIKit>框架中的UIView
 2.UIView的作用是将视图显示在iOS设备的window中，SCNView的作用是显示一个3D场景，ARScnView的作用也是显示一个3D场景，只不过这个3D场景是由摄像头捕捉到的现实世界图像构成的
 */
//AR视图:展示3D界面
@property (nonatomic, strong) ARSCNView *arSCANView;
//2.ARSCNView只是一个视图容器，它的作用是管理一个ARSession,笔者称之为AR会话。
//AR会话，负责管理相机追踪配置及3D相机坐标
@property(nonatomic,strong)ARSession *arSession;
//会话追踪配置：负责追踪相机的运动
@property(nonatomic,strong) ARWorldTrackingConfiguration *arSessionConfiguration;
//飞机3D模型(本小节加载多个模型)
@property(nonatomic,strong)SCNNode *planeNode;

@end

@implementation ARScanViewController
//回话追踪配置
- (ARWorldTrackingConfiguration *)arSessionConfiguration  API_AVAILABLE(ios(11.0)){
    if (!_arSessionConfiguration) {
        //创建3D世界追踪回话位置(使用ARWorldTrackingConfiguration效果更好),需要A9芯片支持,6s以后机型
        self.arSessionConfiguration = [[ARWorldTrackingConfiguration alloc] init];
        //2.设置追踪方向(追踪平面,后面会用到)
        self.arSessionConfiguration.planeDetection = ARPlaneDetectionHorizontal;
        //3.自适应灯光(相机从暗到强光快速过渡效果会平缓一些)]
        self.arSessionConfiguration.lightEstimationEnabled = YES;
    }
    return _arSessionConfiguration;
}
//拍摄回话
- (ARSession *)arSession  API_AVAILABLE(ios(11.0)){
    if (!_arSession) {
        self.arSession = [[ARSession alloc] init];
    }
    return _arSession;
}
//创建AR视图
- (ARSCNView *)arSCANView  API_AVAILABLE(ios(11.0)){
    if (!_arSCANView) {
        //创建AR视图
        self.arSCANView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        //创建试图回话
        self.arSCANView.session = self.arSession;
        //3.自动刷新灯光(3D游戏用到,此处可忽略)
        self.arSCANView.automaticallyUpdatesLighting = YES;
    }
    return _arSCANView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
/**
 ***这里需要特别注意的是，最好将开启ARSession的代码放入viewDidAppear而不是viewDidLoad中，这样可以避免线程延迟的问题。开启ARSession的代码可不可以放入viewDidLoad中呢？答案是可以的，但是笔者不建议大家那么做***
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //将AR视图添加到当前视图
    [self.view addSubview:self.arSCANView];
    //2.开启AR回话(此处相机开始工作)
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
}

#pragma mark- 点击屏幕添加飞机
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.使用场景加载scn文件（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D飞机）--------在右侧我添加了许多3D模型，只需要替换文件名即可
    SCNScene *scene = [SCNScene sceneNamed:@"机器人.max"];
    //2.获取飞机节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
    //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
    SCNNode *shipNode = scene.rootNode.childNodes[0];

    //椅子比较大，可以可以调整Z轴的位置让它离摄像头远一点，，然后再往下一点（椅子太高我们坐不上去）就可以看得全局一点
    shipNode.position = SCNVector3Make(0, -1, -1);//x/y/z/坐标相对于世界原点，也就是相机位置

    //3.将飞机节点添加到当前屏幕中
    [self.arSCANView.scene.rootNode addChildNode:shipNode];
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
