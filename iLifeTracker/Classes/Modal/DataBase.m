
//
//  Created by Adrian
//  Copyright (c) 2013 3rd Floor Software Solutions Inc. All rights reserved.
//

#import "DataBase.h"
#import "RewardModel.h"

@implementation DataBase



static DataBase *_objDataBase = nil;

+ (DataBase *) DatabasesharedInstance {
    if (_objDataBase == nil) {
        _objDataBase = [[DataBase alloc] init];
    }
    
    return _objDataBase;
}

//Create Connecton from database
-(void) dataBaseConnection{
    
    if(LOGS_ON) NSLog(@"DataBase : dataBaseConnection :-> data base");
    
    NSFileManager *fileManager  =    [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths              =    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir      =    [paths objectAtIndex:0];
    _databasePath               =    [documentsDir stringByAppendingPathComponent:@"iLifeTracker.sqlite"];
    if([fileManager fileExistsAtPath:_databasePath]==NO){
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"iLifeTracker" ofType: @"sqlite"];
        BOOL success            = [fileManager copyItemAtPath:defaultDBPath toPath:_databasePath error:&error];
        if(!success){
        }else{
        }
    }
    
}




#pragma mark -
#pragma Mark Insert data in database
/*
 @Description: Insert data in any table of database . 
 */
-(void) insertData:(NSString *) query
{
    [self dataBaseConnection];
    
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		//if(LOGS_ON) NSLog(@"DataBase : insertData :-> welcome");
        
        NSString *insertStatement = query ;
        char *error;
        if ( sqlite3_exec(database, [insertStatement UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
           // if(LOGS_ON) NSLog(@"DataBase : insertData :-> done %@",error);
        }
        
        //if(LOGS_ON) NSLog(@"DataBase : insertData :-> done %@",error);
    }
	sqlite3_close(database);
}



#pragma mark:->
#pragma Select Data from Database
/*
 @Description: Select Only One Atribute from  any table of database . 
 */
-(NSMutableArray *) selectRowForAnyTable:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString *name      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                [myFavoriteDataArry addObject:name];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return myFavoriteDataArry;
}


#pragma mark:->
#pragma Select Data from Database
/*
 @Description: Select Only One Atribute from  any table of database . 
 */
-(NSMutableArray *) selectTrackerDetail:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                TrackerDetailModel *obj = [[TrackerDetailModel alloc] init];
                obj.trackerName      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                obj.trackerCategory  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.trackerSetion    = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.trackerSessionID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; 
                obj.goal      =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]; 
                obj.alaram    =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                obj.autoStop  =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return myFavoriteDataArry;
}




#pragma mark:->
#pragma Select Data from Tracker

-(NSMutableArray *) selectTrackerSessionDetail:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                TrackerSessionModel *obj = [[TrackerSessionModel alloc] init];
                obj.trackerId      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                obj.trackerName  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.trackerCategory    = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.trackerSesion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; 
                obj.trackerStartTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                obj.trackerEndTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                obj.trackerTotalTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]; 
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return myFavoriteDataArry;
}

#pragma mark:->
#pragma Select Data from Tracker
/*
 @Description: Select Only One Atribute from  any table of database . 
 */
-(NSMutableArray *) selectTrackerRecord:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                UpdateTrackerModel *obj = [[UpdateTrackerModel alloc] init];
                obj.trackerName      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                obj.trackerCategory  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.trackerGoal    = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.trackerAlarm = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; 
                obj.trackerNtf = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return myFavoriteDataArry;
}


#pragma mark:->
#pragma Select Data from Tracker
/*
 @Description: Select Only One Atribute from  any table of database . 
 */
-(NSMutableArray *) selectMyLifeData:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                CategoryInfoModel *obj = [[CategoryInfoModel alloc] init];
                obj.trackerName      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                obj.trackerCategory  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.totalTime        = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.maxTime          = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; 
                obj.trackercount     = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return myFavoriteDataArry;
}


#pragma mark:->
#pragma Select Data from Mylife Recent Activity

-(NSMutableArray *) selectMylifeRecentActivity:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                TrackerSessionModel *obj = [[TrackerSessionModel alloc] init];
                obj.trackerName  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                obj.trackerStartTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.trackerEndTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.trackerSesion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]; 
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return myFavoriteDataArry;
}


#pragma mark:->
#pragma Select Data from Mylife Recent Activity

-(NSMutableArray *) selectGraphInfo:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                GraphModel *obj = [[GraphModel alloc] init];
                obj.trackerName  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                obj.trackerSesion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.currentSession = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.trackerStartTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                obj.trackerEndTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                              
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return myFavoriteDataArry;
}


#pragma mark:->
#pragma Select Data from Mylife Recent Activity

-(NSMutableArray *) selectCurrentSession:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                CrntSessionModel *obj = [[CrntSessionModel alloc] init];
                obj.trackerName  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                obj.timeCounter = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.startDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.storeDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                obj.pauseCounter = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                obj.indexNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                obj.pauseIdentify = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                obj.runIdentify = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return myFavoriteDataArry;
}




//Reward.

-(NSMutableArray *) selectRewardData:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                RewardModel *obj = [[RewardModel alloc] init];
                obj.categoryName      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                obj.tolatTime  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
//    for (int i = 0; i < [myFavoriteDataArry count]; i++) {
//        RewardModel *objCategoryModel = [myFavoriteDataArry objectAtIndex:0];
//        NSLog(@"category name for selectRewardData :-> %@",objCategoryModel.categoryName);
//        NSLog(@"total for selectRewardData :-> %@",objCategoryModel.tolatTime);
//    }

    
	return myFavoriteDataArry;
}


-(NSMutableArray *) selectRewardMessageData:(NSString *) query
{
    [self dataBaseConnection];
    NSMutableArray *myFavoriteDataArry              = [[NSMutableArray alloc] init];
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                RwardMessageModel *obj = [[RwardMessageModel alloc] init];
                obj.categoryName      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                obj.rewardInterval  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.rewardImage  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.rewardMessage1  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                obj.rewardMessage2  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                obj.rewardMessage3  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                obj.rewardMessage4  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                obj.rewardMessage5  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                obj.starCount =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                [myFavoriteDataArry addObject:obj];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	

    
    
	return myFavoriteDataArry;
}


-(long ) overAllToalTime:(NSString *) query
{
    [self dataBaseConnection];
    long totalTime;
	sqlite3 *database;
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement    = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
              
               totalTime = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] intValue];
              
                
			}
		}
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
  
	return totalTime;
}




@end
