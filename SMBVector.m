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

//properties
-(NSUInteger) numberOfEntries{
    return _numberOfEntries;
}

-(void) setNumberOfEntries:(NSUInteger)value
{
    _numberOfEntries = value;
}

-(NSMutableArray*) data{
    return _data;
}

-(void) setData:(NSMutableArray*) dataArray
{
    [dataArray retain];
    [_data release];
    _data = dataArray;
}

//mutators
-(void) calculateNumberOfEntries
{
	_numberOfEntries = [_data count];
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
-(void) printVector
{
    NSMutableString* message = [[NSMutableString alloc] init];
    [message appendFormat:@"vector\n%@", [self vectorString]];
    NSLog(@"%@", message);
    [message release];
}

-(NSMutableString*) vectorString
{
    NSMutableString* message = [[NSMutableString alloc] init];
    //[message appendString:@"\n"];
    for (NSUInteger i=0; i<_numberOfEntries; i++){
        [message appendFormat:@"%@\t", [_data objectAtIndex: i]];
    }
    [message appendString:@"\n"];
    [message autorelease];
    return message;
}


//deallocator
-(void) dealloc
{
    NSLog(@"SMBVector deallocated");
    [_data release];
    _data = nil;
    [super dealloc];
}
@end
