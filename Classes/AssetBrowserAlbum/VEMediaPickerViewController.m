//
//  VEImagePickerViewController.m
//  VE
//
//  Created by XianJing on 13-6-25.
//  Copyright (c) 2013年 Sikai. All rights reserved.
//

#import "VEMediaPickerViewController.h"
#import "VECollectionViewLayout.h"
#import "VECollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CELL_REUSE_ID @"VEViewCell"

@implementation VEMediaPickerViewController

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        VECollectionViewLayout *flowLayout = [[VECollectionViewLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(75, 75);
        flowLayout.minimumInteritemSpacing = 3;
        flowLayout.minimumLineSpacing = 4;
        flowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
        flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
        flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 60);
        
        self = [super initWithCollectionViewLayout:flowLayout];
        
        [self.collectionView registerClass:[VECollectionViewCell class] forCellWithReuseIdentifier:CELL_REUSE_ID];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    UIBarButtonItem *videoBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Video" style:UIBarButtonItemStylePlain target:self action:@selector(videoAction:)];
    UIBarButtonItem *photoBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Photo" style:UIBarButtonItemStylePlain target:self action:@selector(photoAction:)];
    
    self.navigationItem.leftBarButtonItems = [NSMutableArray arrayWithObjects:cancelBarBtn, videoBarBtn, photoBarBtn,nil];
    
    self.photoAssetList = [[NSMutableArray alloc] init];
    self.videoAssetList = [[NSMutableArray alloc] init];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [self.spinner setCenter:self.view.center];
    [self.spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.spinner startAnimating];
    [self.videoAssetList removeAllObjects];
    [self.photoAssetList removeAllObjects];
    
    [self getAsset];
}

- (void) onRefreshGroupList: (NSDictionary*)groups {
    
    [self.spinner stopAnimating];
    self.usingAssetArray = [self.videoAssetList copy];
    dispatch_async(dispatch_get_main_queue(), ^{[self.collectionView reloadData]; });
}

- (void) onRefreshGroupItem: (NSString*)name assetArray:(NSArray*)array {
    
    for (int i=0; i<[array count]; i++) {
        
        ALAsset *asset = [array objectAtIndex:i];
        NSString *type = [asset valueForProperty:ALAssetPropertyType];

        if ([type compare:ALAssetTypeVideo] == NSOrderedSame) {
            [self.videoAssetList addObject:asset];
        } else {
            [self.photoAssetList addObject:asset];
        }
        
    }
}

-(void) getAsset
{
    ALAssetsLibrary *_AssetsLibrary;
    
    _AssetsLibrary = [[ALAssetsLibrary alloc] init];
    
    __block NSMutableDictionary* groupDict = [[NSMutableDictionary alloc] init];
    
    [_AssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                      
                                      if (group == nil) {
                                          // group == nil 这次枚举已经完成.
                                          [self onRefreshGroupList:groupDict];
                                          return ;
                                      }
                                      
                                      __block NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                                      __block NSMutableArray* itemArray = [[NSMutableArray alloc] init];
                                      
                                      [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                          
                                          if (result == nil) {
                                              
                                              [groupDict setValue:itemArray forKey:groupName];
                                              [self onRefreshGroupItem:groupName assetArray:itemArray];
                                              return ;
                                          }
                                          
                                          [itemArray addObject:result];
                                      }];
                                  }
                                failureBlock:^(NSError *error) {
                                    NSLog(@"[ny] error %@",error);
                                }];
}

#pragma mark - UICollectionViewDataSource functions

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.usingAssetArray == nil)
        return 0;
    return [self.usingAssetArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_REUSE_ID forIndexPath:indexPath];
    NSUInteger index = [indexPath indexAtPosition:1];
    ALAsset *asset = [self.usingAssetArray objectAtIndex:index];
    
    [cell setALAsset:asset];
    return cell;
}

#pragma mark - UICollectionViewDelegate functions

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.usingAssetArray objectAtIndex:indexPath.row];
    NSURL *url = [asset valueForProperty:ALAssetPropertyAssetURL];
    
    NSLog(@"[ny] asset: %@",url);
    
    if ([self.delegate respondsToSelector:@selector(assetBrowserAlbum:)]) {
        [[self retain] autorelease];
        [self.delegate assetBrowserAlbum:asset];
    }
         
    return NO;
}

#pragma mark - bar button action
- (void)cancelAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(assetBrowserAlbumDidCancel)]) {
		[[self retain] autorelease];
		[self.delegate assetBrowserAlbumDidCancel];
	}
}

- (void)videoAction:(id)sender {
    self.usingAssetArray = [self.videoAssetList copy];
    [self.collectionView reloadData];
}

- (void)photoAction:(id)sender {
    self.usingAssetArray = [self.photoAssetList copy];
    [self.collectionView reloadData];
}

@end
