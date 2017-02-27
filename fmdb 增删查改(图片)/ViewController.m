//
//  ViewController.m
//  fmdb 增删查改(图片)
//
//  Created by imac on 2017/2/24.
//  Copyright © 2017年 imac. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface ViewController ()

@property (nonnull, strong) FMDatabaseQueue * queue;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //数据库在沙盒中的路径
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(13, 1, 1)lastObject]stringByAppendingPathComponent:@"testOfFMDB.sqlite"];
    NSLog(@"%@",fileName);
    
    //创建数据库
    self.queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            BOOL createTable = [db executeUpdate:@"create table if not exists t_testOfFMDB (id integer primary key autoincrement,image blob)"];
            if (createTable) {
                NSLog(@"创建表成功");
            }
            else{
                NSLog(@"创建表失败");
            }
        }
        
        [db close];
    }];
    
}
- (IBAction)insert:(id)sender {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            NSData * data = UIImageJPEGRepresentation([UIImage imageNamed:@"BG.jpg"], 1);
            
            BOOL flag = [db executeUpdate:@"insert into t_testOfFMDB (image) values(?)",data];
            
            if (flag) {
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
            }
            
            
        }
        [db close];
    }];
    
}


- (IBAction)delete:(id)sender {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            BOOL flag = [db executeUpdate:@"delete from t_testOfFMDB"];
            
            if (flag) {
                NSLog(@"删除成功");
            }else{
                NSLog(@"删除失败");
            }
        }
        
        
        [db close];
    }];
    
    
}
- (IBAction)update:(id)sender {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            NSData * data = UIImageJPEGRepresentation([UIImage imageNamed:@"CX.jpg"], 1);
            
            BOOL flag = [db executeUpdate:@"update t_testOfFMDB set image = ?",data];
            
            if (flag) {
                NSLog(@"修改成功");
            }else{
                NSLog(@"修改失败");
            }
        }
        [db close];
    }];
    
}
- (IBAction)select:(id)sender {
    
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            //返回查询数据的结果集
            FMResultSet * resultSet = [db executeQuery:@"select * from t_testOfFMDB"];
            //查询表中的每一个记录
            while ([resultSet next]) {
                
                NSData * data = [resultSet dataForColumn:@"image"];
                
                UIImage * image = [UIImage imageWithData:data];
                
                self.imageView.image = image;
                
            }
            
        }
        [db close];
    }];
    
    
}

@end
