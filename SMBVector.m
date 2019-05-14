/* ######################################################################
* File Name: SMBVector.m
* Project: fossa
* Version: 19.05
* Creation Date: 11.05.2019
* Created By: Sebastian Malkusch
* Contact: <malkusch@chemie.uni-frankfurt.de>
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
*
* License
* Copyright (C) 2019  Sebastian Malkusch
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
#######################################################################*/

#import <Foundation/Foundation.h>
#import "SMBVector.h"

@implementation SMBVector
// initializer
-(id) init
{
    self=[super init];
    if(self){
        _numberOfEntries = 0;
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id) initWithSize:(NSUInteger)value
{
    self=[super init];
    if(self){
        _numberOfEntries = value;
        _data = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<value; i++){
            [_data addObject:[NSNumber numberWithInt:0]];
        }
    }
    return self;
}

//properties
-(NSUInteger) numberOfEntries{
    return _numberOfEntries;
}

-(void) setNumberOfEntries:(NSUInteger)value
{
    _numberOfEntries = value;
}

-(NSMutableArray*) _data{
    return _data;
}

//mutators
-(NSNumber*) objectAtIndex:(NSUInteger) idx
{
    NSException* exception = [[NSException alloc]
                              initWithName:@"SMBVector out of range error"
                              reason:@"objectAtIndex points to an entry that exceeds matrix dimensions"
                              userInfo:nil];
    if(![self proofIfEntryExists:idx]){
        [exception raise];
    }
    [exception release];
    return [_data objectAtIndex: idx];
}

-(void) replaceObjectAtIndex:(NSUInteger) idx with:(NSNumber*)object
{
    NSException* exception = [[NSException alloc]
                              initWithName:@"SMBVector out of range error"
                              reason:@"replaceObjectAtIndex points to an entry that exceeds matrix dimensions"
                              userInfo:nil];
    if(![self proofIfEntryExists:idx]){
        [exception raise];
    }
    [_data replaceObjectAtIndex:idx
                     withObject:object];
    [exception release];
}

//load functions
-(void) readCsv: (NSString*) startCharacter :(NSString*) fileName
{
    //free _data
    [_data removeAllObjects];
    // define exceptions
    NSException* exceptionFile = [[NSException alloc]
                                  initWithName:@"SMBVector file Name error"
                                  reason:@"could not read from file. Make sure the path exists."
                                  userInfo:nil];
    
    NSException* exceptionCharacter = [[NSException alloc]
                                       initWithName:@"SMBVector character error"
                                       reason:@"Fossa found matrix entry of wrong type!"
                                       userInfo:nil];

    NSException* exceptionStart = [[NSException alloc]
                                  initWithName:@"SMBVector start character error"
                                  reason:@"could not find start character in file. Make sure it exists."
                                  userInfo:nil];
    // proof if file exists
    NSFileManager* fm = [[NSFileManager alloc] init];
    if(![fm fileExistsAtPath:fileName]){
        [exceptionFile raise];
        return;
    }
    // define error
    NSError* error;
    error = nil;
    // load file
    NSString* rawFileContent = [NSString stringWithContentsOfFile: fileName
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
    if(error != nil){
        NSLog(@"Fossa detected an error:\n%@", error);
	return;
    }
    //convert string contents to NSNumber
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setDecimalSeparator:@"."];
    NSArray* rows = [rawFileContent componentsSeparatedByString:@"\n"];
    bool foundStart = false;
    for(NSString* row in rows){
        NSRange range = [row  rangeOfString:startCharacter];
        if (range.location != NSNotFound){
            foundStart = true;
            continue;
        }
        if(foundStart){
            NSArray* columns = [row componentsSeparatedByString:@","];
            for(NSString* stringEntry in columns){
                NSNumber* numberEntry = [formatter numberFromString:stringEntry];
                if(numberEntry != nil){
                    [_data addObject: numberEntry];
                }
                else{
                    [exceptionCharacter raise];
                    return;
                }
            }
            [self setNumberOfEntries: [_data count]];
            break;
        }
    }
    if(!foundStart){
	[exceptionStart raise];
    }
    [exceptionFile release];
    [exceptionCharacter release];
    [fm release];
    [error release];
    [rawFileContent release];
    [rows release];
    return;
}

//proof functions
-(bool) proofVectorDimension
{
    NSUInteger arrayLength = [_data count];
    if (arrayLength != _numberOfEntries){
        return false;
    }
    return true;
}

-(bool) proofIfEntryExists:(NSUInteger) idx
{
    NSUInteger arrayLength = [_data count];
    if (arrayLength <= idx){
        return false;
    }
    return true;
}

//print Methods
-(void) printVectorAsInt
{
    NSMutableString* message = [[NSMutableString alloc] init];
    [message appendString:@"\n"];
    for (NSUInteger i=0; i<_numberOfEntries; i++){
        [message appendFormat:@"%i\t", [[_data objectAtIndex: i] intValue]];
    }
    [message appendString:@"\n"];
    NSLog(@"%@", message);
    [message release];
}

-(void) printVectorAsFloat
{
    NSMutableString* message = [[NSMutableString alloc] init];
    [message appendString:@"\n"];
    for (NSUInteger i=0; i<_numberOfEntries; i++){
        [message appendFormat:@"%.3f\t", [[_data objectAtIndex: i] doubleValue]];
    }
    [message appendString:@"\n"];
    NSLog(@"%@", message);
    [message release];
}

//deallocator
-(void) dealloc
{
    NSLog(@"Vector deallocated");
    [_data release];
    _data = nil;
    [super dealloc];
}
@end
