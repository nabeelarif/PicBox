//
//  UserDefaultBaseModel.m
//  PicBox
//
//  Created by Nabeel on 10/06/2014.
//  Copyright (c) 2014 Nabeel. All rights reserved.
//

#import "UserDefaultBaseModel.h"
#import <objc/runtime.h>

@implementation UserDefaultBaseModel


- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSArray *columns =[self getColumns];
    for (NSString *cColumn in columns) {
        [encoder encodeObject:[self valueForKey:cColumn] forKey:cColumn];
    }
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        NSArray *columns =[self getColumns];
        for (NSString *cColumn in columns) {
            [self setValue:[decoder decodeObjectForKey:cColumn] forKeyPath:cColumn];
        }
    }
    return self;
}


-(NSArray*)getColumns
{
    NSMutableArray *columns = [NSMutableArray new];
    
    unsigned int varCount;
    
    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        
        const char* name = ivar_getName(var);
        [columns addObject:[NSString stringWithFormat:@"%s",name]];
    }
    
    free(vars);
    
    return columns;
}
-(void)saveCurrentState:(NSString*)key
{
    // Save current object to NSuserdefaults
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
}

-(void)clearData:(NSString*)key
{
    
    // Remove data from user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    
    // Set values to nil
    NSArray *columns =[self getColumns];
    for (NSString *cColumn in columns) {
        [self setValue:nil forKeyPath:cColumn];
    }
}
-(void)saveCurrentState
{
    [self saveCurrentState:NSStringFromClass([self class])];
}
-(void)clearData
{
    // Remove data from user defaults
    [self clearData:NSStringFromClass([self class])];
}
@end
