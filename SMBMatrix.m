/* ######################################################################
 * File Name: SMBMatrix.m
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
#import "SMBMatrix.h"

@implementation SMBMatrix
//initializer
-(id) init
{
    self=[super init];
    if(self){
        _numberOfColumns = 0;
        _numberOfRows = 0;
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}
-(id) initWithSize :(NSUInteger) columnNumber :(NSUInteger) rowNumber
{
    self=[super init];
    if(self){
        _numberOfColumns = columnNumber;
        _numberOfRows = rowNumber;
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

//Properties
-(void) setNumberOfColumns:(NSUInteger)columnNumber
{
    _numberOfColumns = columnNumber;
}

-(NSUInteger) numberOfColumns
{
    return _numberOfColumns;
}

-(void) setNumberOfRows:(NSUInteger)rowNumber
{
    _numberOfRows = rowNumber;
}

-(NSUInteger) numberOfRows
{
    return _numberOfRows;
}

-(void) setData:(NSMutableArray*) dataArray
{
    [dataArray retain];
    [_data release];
    _data = dataArray;
}

-(NSMutableArray*) data
{
    return _data;
}

//mutators
-(NSNumber*) objectAtIndex:(NSUInteger) rowIdx :(NSUInteger) columnIdx
{
    NSException* exception = [[NSException alloc]
                       initWithName:@"SMBMatrix out of range error"
                       reason:@"objectAtIndex points to an entry that exceeds matrix dimensions"
                       userInfo:nil];
    if(![self proofIfEntryExists:rowIdx :columnIdx]){
        [exception raise];
    }
    [exception release];
    return [_data objectAtIndex: (rowIdx*_numberOfColumns+columnIdx)];
}

-(void) replaceObjectAtIndex:(NSUInteger)rowIdx :(NSUInteger)columnIdx with:(NSNumber*)object
{
    NSException* exception = [[NSException alloc]
                              initWithName:@"SMBMatrix out of range error"
                              reason:@"replaceObjectAtIndex points to an entry that exceeds matrix dimensions"
                              userInfo:nil];
    if(![self proofIfEntryExists:rowIdx :columnIdx]){
        [exception raise];
    }
    [_data replaceObjectAtIndex:(rowIdx * _numberOfColumns + columnIdx)
                     withObject:object];
    [exception release];
}

// proof methods
-(bool) proofMatrixDimensions
{
    NSUInteger arrayLength = [_data count];
    if (arrayLength != _numberOfRows * _numberOfColumns){
        NSLog(@"Fosser error: The imported matrix does not match the expected matrix dimensions.");
        return false;
    }
    return true;
}

-(bool) proofIfEntryExists:(NSUInteger) rowIdx :(NSUInteger) columnIdx
{
    if(rowIdx >= _numberOfRows){
        return false;
    }
    if(columnIdx >= _numberOfColumns){
        return false;
    }
    NSUInteger arrayLength = [_data count];
    if (arrayLength <= (rowIdx * _numberOfColumns + columnIdx)){
        return false;
    }
    return true;
}

//print Methods
-(void) printMatrix
{
    NSMutableString* message = [[NSMutableString alloc] init];
    [message appendString:@"\n"];
    for (NSUInteger i=0; i<_numberOfRows; i++){
        for(NSUInteger j=0; j<_numberOfColumns; j++){
            [message appendFormat:@"%i\t", [[_data objectAtIndex: (i*_numberOfColumns+j)] intValue]];
        }
        [message appendString:@"\n"];
    }
    NSLog(@"%@", message);
    [message release];
}

//deallocator
-(void) dealloc
{
    NSLog(@"Matrix deallocated");
    [_data release];
    _data = nil;
    [super dealloc];
}
@end
