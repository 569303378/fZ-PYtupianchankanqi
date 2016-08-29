//
//  ViewController.m
//  PYtupianchakanqi
//
//  Created by Apple on 16/8/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "MWPhotoBrowser.h"//图片管理器

@interface ViewController () <SDCycleScrollViewDelegate, MWPhotoBrowserDelegate>
@property (nonatomic,strong)NSArray * picUrls;
@property (nonatomic,strong)NSMutableArray * photos;

@property (nonatomic,strong)NSMutableArray * selections;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self PYlunbotu];
}

#pragma mark = 轮播图
- (void)PYlunbotu {
    // 情景二：采用网络图片实现
    self.picUrls = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"新建交流QQ群：185534916 ",
                        @"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com"
                        ];
    
   //带标题的轮播图
    SDCycleScrollView *SDCSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 200) delegate:self placeholderImage:[UIImage imageNamed:@"123.png"]];
    //小圆点位置
    SDCSV.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    SDCSV.titlesGroup = titles;
    SDCSV.currentPageDotColor = [UIColor whiteColor];//小圆点
    SDCSV.imageURLStringsGroup = self.picUrls;
    [self.view addSubview:SDCSV];
    
    /*
     需要数据源：是 MWPhoto类 的数组。
     
     + (MWPhoto *)photoWithImage:(UIImage *)image;// 本地图片
     + (MWPhoto *)photoWithURL:(NSURL *)url;// URL 图片
     + (MWPhoto *)photoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize;// 照片
     + (MWPhoto *)videoWithURL:(NSURL *)url; // 视频
     
     @property (nonatomic, strong) NSString *caption;// 描述
     
     @property (nonatomic, strong) NSURL *videoURL;
     @property (nonatomic) BOOL emptyImage;
     @property (nonatomic) BOOL isVideo;
     */
    
    //创建图片管理器
    MWPhoto * photo;
    _photos = [NSMutableArray new];
    for (NSString * urlStr in _picUrls) {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:urlStr]];
        [_photos addObject:photo];
    }
}

#pragma mark - SDCycleScrollViewDelegate 点击图片方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    //图片浏览器
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    
    /*
     包含属性
     
     @property (nonatomic) BOOL displayNavArrows;// toolBar 上的 左右翻页 ，默认 NO
     @property (nonatomic) BOOL displayActionButton;// 系统分享
     @property (nonatomic) BOOL alwaysShowControls;// 是否一直显示 导航栏
     
     @property (nonatomic) BOOL displaySelectionButtons;// 选择图片
     @property (nonatomic, strong) NSString *customImageSelectedIconName;// 选择大图
     @property (nonatomic, strong) NSString *customImageSelectedSmallIconName;// 选择小图
     
     @property (nonatomic) BOOL enableGrid;// 是否可以查看小图预览模式
     @property (nonatomic) BOOL startOnGrid;// 以小图预览模式进入
     
     @property (nonatomic) BOOL autoPlayOnAppear;// 自动播放视频
     @property (nonatomic) NSUInteger delayToHideElements;// 延迟 隐藏时间
     @property (nonatomic) BOOL zoomPhotosToFill;//
     
     @property (nonatomic, readonly) NSUInteger currentIndex;// 当前位置
     */
    browser.displayActionButton = NO;
    browser.enableGrid = NO;
    // push 显示！
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark  MWPhotoBrowserDelegate
//数量
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

// 内容
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

// 网格视图
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"3");
//
//    if (index < _photos.count)
//        return [_photos objectAtIndex:index];
//    return nil;
//}

// nav title
//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return @"123";
//}

// 已经 显示
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"%zi",index);

}

// 是否选中，需要结合属性设置，同时使用 NSNumber 的数组
//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    NSLog(@"5");
//
//    return [[_selections objectAtIndex:index] boolValue];
//}

// 选择某个
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"6");
//
//}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
