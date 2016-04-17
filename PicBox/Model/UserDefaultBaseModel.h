//
//  UserDefaultBaseModel.h
//  PicBox
//
//  Created by Nabeel on 10/06/2014.
//  Copyright (c) 2014 Nabeel. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 A base model class for data elements which will be stored in User defaults.
 They will mostly adopt singleton pattern. Most common methods are accomodated in this
 class to simplify the logic of child classes.
 
 This class uses objective c runtime library to extract properties of the class to save them properly 
 into user-defaults. This will generalize our most of the implementation from child classes. It also 
 implements NSCoding protocol so that the object could be saved to user defaults as a whole
 */
@interface UserDefaultBaseModel : NSObject <NSCoding>

/**
 Saves the data of current object to User defaults.
 */
-(void)saveCurrentState;
/**
 Clears current object from the user defaults and set default values to nil;
 */
-(void)clearData;

@end
