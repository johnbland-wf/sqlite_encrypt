//
//  JBViewController.m
//  SqliteEncrypted

#import "JBViewController.h"
#import <Sqlite3/sqlite.h>
#import "NSString+Helpers.h"
#import "WFRandomizer.h"

@interface JBViewController ()

@end

@implementation JBViewController

const NSString *databaseName = @"encrypted.sqlite3";
NSString *databaseDirectory;
NSString *databasePath;
sqlite3 *db;

- (void)viewDidLoad {
    NSError *error;
    databaseDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    databasePath = [NSString stringWithFormat:@"%@/%@", databaseDirectory, databaseName];

    if (error) {
        NSLog(@"Error creating or opening DB: %@", error.description);
    }
}

- (IBAction)startWasTouched:(id)sender{
    [self createDatabase];
}

- (void)createDatabase{
    NSLog(@"Creating Database: %@", databasePath);

    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [@"BIGSecret" UTF8String];
        sqlite3_key(db, key, strlen(key));
        NSLog(@"Decrypted");
        if (sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
            // password is correct, or, database has been initialized
            NSLog(@"password worked");

            [self countRows];

//            [self setupSchema];
        } else {
            NSLog(@"password failed");
        }
        
        sqlite3_close(db);
    }
}

- (void)setupSchema{
    NSLog(@"SCHEMA begin");

    NSString *query = @"CREATE TABLE IF NOT EXISTS TestData (id INTEGER PRIMARY KEY, field1 TEXT, field2 TEXT, field3 TEXT, field4 TEXT, field5 TEXT);";
    if (sqlite3_exec(db, (const char*) [query UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
        NSLog(@"SCHEMA end");

        [self insertRows];
    } else {
        NSLog(@"SCHEMA failed");
    }
}

- (void)countRows{
    NSLog(@"COUNT begin");

    const char *sql = "SELECT count(*) FROM TestData";
    sqlite3_stmt *selectStatement;
    if (sqlite3_prepare_v2(db, sql, -1, &selectStatement, NULL) == SQLITE_OK) {
        if (sqlite3_step(selectStatement) == SQLITE_ROW) {
            NSString *count = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStatement, 0)];
            NSLog(@"RECORDS: %@", count);
        }else{
            NSLog(@"Not found");
        }
        sqlite3_reset(selectStatement);
    }
}

- (void)insertRows{
    NSLog(@"INSERT: Begin");

    if (sqlite3_exec(db, (const char*) "DELETE FROM TestData;", NULL, NULL, NULL) != SQLITE_OK) {

    }

    NSNumber *rowId;

    NSString *insertSQL;

    for (int i=0; i < 1000000; i++) {
        rowId = [NSNumber numberWithInt:(i + 1)];
        insertSQL = [self createInsertStatement:rowId values:[self randomFieldValues]];

        if (sqlite3_exec(db, (const char*) [insertSQL UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
            NSLog(@"INSERT failed");
        }
    }

    NSLog(@"INSERT: End");
}

- (NSString *)createInsertStatement:(NSNumber *)rowID values:(NSArray *)values {
    NSString *query = @"INSERT INTO TestData (id, field1, field2, field3, field4, field5) VALUES ({0}, '%@', '%@', '%@', '%@', '%@');";

    query = [NSString stringWithFormat:query array:values];
    return [query stringByReplacingOccurrencesOfString:@"{0}" withString:[rowID stringValue]];
}

- (void)decryptDatabase{
    NSLog(@"Decrypting Database");
}

- (void)deleteDatabase{
    NSLog(@"Deleting Database");
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL exists = [fileManager fileExistsAtPath:databasePath];
    if ([fileManager fileExistsAtPath:databasePath]) {
        // delete the old sqlite DB
        NSLog(@"Deleting previous SQLite database at %@", databasePath);
        NSError *error;
        [fileManager removeItemAtPath:databasePath error:&error];

        if (error) {
            NSLog(@"ERROR: %@", error.description);
        }
    }
}

- (NSArray *)randomFieldValues {
    return [NSArray arrayWithObjects:[[WFRandomizer sharedInstance] randomItem],
            [[WFRandomizer sharedInstance] randomItem],
            [[WFRandomizer sharedInstance] randomItem],
            [[WFRandomizer sharedInstance] randomItem],
            [[WFRandomizer sharedInstance] randomItem],
            nil];
}

@end