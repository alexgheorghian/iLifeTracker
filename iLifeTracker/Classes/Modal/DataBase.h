


#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "TrackerDetailModel.h"
#import "TrackerSessionModel.h"
#import "UpdateTrackerModel.h"
#import "CategoryInfoModel.h"
#import "GraphModel.h"
#import "CrntSessionModel.h"
#import "RwardMessageModel.h"


@interface DataBase : NSObject{
    NSString                *_databasePath;
}

+ (DataBase *) DatabasesharedInstance;

-(void) dataBaseConnection;

-(void) insertData:(NSString *) query;

-(NSMutableArray *) selectRowForAnyTable:(NSString *) query;

-(NSMutableArray *) selectTrackerDetail:(NSString *) query;

-(NSMutableArray *) selectTrackerSessionDetail:(NSString *) query;

-(NSMutableArray *) selectTrackerRecord:(NSString *) query;

-(NSMutableArray *) selectMyLifeData:(NSString *) query;

-(NSMutableArray *) selectMylifeRecentActivity:(NSString *) query;

-(NSMutableArray *) selectGraphInfo:(NSString *) query;

-(NSMutableArray *) selectCurrentSession:(NSString *) query;

//Reward.
-(NSMutableArray *) selectRewardData:(NSString *) query;
-(NSMutableArray *) selectRewardMessageData:(NSString *) query;
-(long ) overAllToalTime:(NSString *) query;
@end
