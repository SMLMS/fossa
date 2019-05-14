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
-(id) init :(NSUInteger) columnNumber :(NSUInteger) rowNumber
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

-(NSMutableArray*) data
{
    return _data;
}

//mutators
-(id) objectAt:(NSUInteger) rowIdx :(NSUInteger) columnIdx
{
    
    NS_DURING{
        NSException* ex = [[NSException alloc]
                           initWithName:@"SMBMatrix out of range error"
                           reason:@"objectAt point to an entry that exceeds matrix dimensions"
                           userInfo:nil];
        if(![self proofIfEntryExists:rowIdx :columnIdx]){[ex raise];}
    }
    NS_HANDLER{
        [localException raise];
    }
    NS_ENDHANDLER
    return [_data objectAtIndex: (rowIdx*_numberOfColumns+columnIdx)];
}

-(void) setObjectAt:(NSUInteger) rowIdx :(NSUInteger) columnIdx
{
    NSLog(@"under construction");
}
//load functions
-(bool) readCsv:(NSString*) startCharacter :(NSString*) stopCharacter :(NSString *)fileName
{
    //free _data
    [_data removeAllObjects];
    // proof if file exists
    NSFileManager* fm = [[NSFileManager alloc] init];
    if(![fm fileExistsAtPath:fileName]){
        NSLog(@"Fossa detected an error: Could not load file %@\nMake sure it exists.", fileName);
        return false;
    }
    // define error
    NSError* error;
    error = nil;
    // load file
    NSString* rawFileContent = [NSString stringWithContentsOfFile: fileName
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil];
    if(error != nil){
        NSLog(@"Fossa detected an error:\n%@", error);
        return false;
    }
    //convert string contents to NSNumber
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSArray* rows = [rawFileContent componentsSeparatedByString:@"\n"];
    bool foundStart = false;
    for(NSString* row in rows){
        NSRange range = [row  rangeOfString:startCharacter];
        if (range.location != NSNotFound){
            foundStart = true;
            continue;
        }
        range = [row rangeOfString:stopCharacter];
        if(range.location != NSNotFound){
            return true;
        }
        if(foundStart){
            NSArray* columns = [row componentsSeparatedByString:@","];
            for(NSString* stringEntry in columns){
                NSNumber* numberEntry = [formatter numberFromString:stringEntry];
                if(numberEntry != nil){
                    [_data addObject: numberEntry];
                }
                else{
                    NSLog(@"error: Fossa found matrix entry of wrong type!");
                    return true;
                }
            }
        }
    }
    return true;
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
    NSUInteger arrayLength = [_data count];
    if (arrayLength > (rowIdx * _numberOfColumns + columnIdx)){
        return true;
    }
    return false;
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
