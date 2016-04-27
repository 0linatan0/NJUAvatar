//
//  NJUBadgeTableViewController.m
//  NJUAvatar
//
//  Created by tanli on 16/4/26.
//  Copyright © 2016年 tanli. All rights reserved.
//

#import "NJUBadgeTableViewController.h"
#import "NJUBadgeTableViewCell.h"
#import "NJUBadgeViewController.h"
#import "NJUAvatarUserDefaults.h"

@interface NJUBadgeTableViewController ()
{
    UILocalizedIndexedCollation *_collation;
    NSMutableArray *_newSectionsArray;
    NSArray *_badgeList;
}

@property (weak, nonatomic) IBOutlet UITableView *badgeTableView;
@property (weak, nonatomic) NJUBadgeViewController * badgeViewController;

@end

@implementation NJUBadgeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    _badgeTableView.separatorStyle = UITableViewCellAccessoryNone;//去除分割线
    [self initData];
}

- (void)initData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistpath = [bundle pathForResource:@"badges" ofType:@"plist"];
    _badgeList = [[NSArray alloc]initWithContentsOfFile:plistpath];
    
    _collation = [UILocalizedIndexedCollation currentCollation];
    _newSectionsArray = [[NSMutableArray alloc] initWithCapacity:[[_collation sectionTitles] count]];
    
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
    //排序
    for (NSInteger index = 0; index < [[_collation sectionTitles] count]; index++) {
        NSMutableArray *badgeArrayForSection = _newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [_collation sortedArrayFromArray:badgeArrayForSection collationStringSelector:@selector(name)];
        _newSectionsArray[index] = sortedPersonArrayForSection;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_collation sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_newSectionsArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier = @"badgeCellReuseIdentifier";
    NJUBadgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell)
    {
        cell = [[NJUBadgeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    NJUBadge *badgeItem = _newSectionsArray[indexPath.section][indexPath.row];
    [cell fillContentWithBadge:badgeItem];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJUBadge *badgeItem = _newSectionsArray[indexPath.section][indexPath.row];
    UIImage *image = [UIImage imageNamed:badgeItem.imageName];
    [NJUAvatarUserDefaults saveBadge:image];
    
    _badgeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"badgeViewController"];
//    [self presentViewController:badgeViewController animated:YES completion:^{
//        [badgeViewController showAvatar:avatar withBadge:image];
//    }];
    [self.navigationController pushViewController:_badgeViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _collation.sectionTitles[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _collation.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_collation sectionForSectionIndexTitleAtIndex:index];
}

@end
