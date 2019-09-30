/* ######################################################################
* File Name: SMBCharacterVector.m
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
#import "SMBCharacterVector.h"

@implementation SMBCharacterVector
// initializer
-(id) initWithSize:(NSUInteger)value
{
    self=[super init];
    if(self){
        _numberOfEntries = value;
        _data = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<value; i++){
            [_data addObject:[NSMutableString stringWithCapacity:20]];
        }
    }
    return self;
}

//mutators
-(NSMutableArray*) objectAtIndex:(NSUInteger) idx
{
    NSException* exception = [[NSException alloc]
                              initWithName:@"SMBNumericVector out of range error"
                              reason:@"objectAtIndex points to an entry that exceeds vector dimensions"
                              userInfo:nil];
    if(![self proofIfEntryExists:idx]){
        [exception raise];
    }
    return [_data objectAtIndex: idx];
}

-(void) replaceObjectAtIndex:(NSUInteger) idx with:(NSMutableArray*)object
{
    [object retain];
    NSException* exception = [[NSException alloc]
                              initWithName:@"SMBVector out of range error"
                              reason:@"replaceObjectAtIndex points to an entry that exceeds vector dimensions"
                              userInfo:nil];
    if(![self proofIfEntryExists:idx]){
        [exception raise];
    }
    [_data replaceObjectAtIndex:idx
                     withObject:object];
    [object release];
}
@end
