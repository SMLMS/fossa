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

//load functions
-(bool) readCsv:(NSString*) startCharacter :(NSString*) stopCharacter :(NSString *)fileName
{
    //free _data
    [_data removeAllObjects];
    // define error
    NSError* error;
    error = nil;
    //load file to string
    NSString* rawFileContent = [NSString stringWithContentsOfFile: fileName
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    if(error != nil){
        NSLog(@"Fossa detected an error:\n%@", error);
        return FALSE;
    }
    //convert string contents to NSNumber
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSArray* rows = [rawFileContent componentsSeparatedByString:@"\n"];
    bool foundStart = FALSE;
    for(NSString* row in rows){
        NSRange range = [row  rangeOfString:startCharacter];
        if (range.location != NSNotFound){
            foundStart = TRUE;
            continue;
        }
        range = [row rangeOfString:stopCharacter];
        if(range.location != NSNotFound){
            return TRUE;
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
                    return FALSE;
                }
            }
        }
    }
    return TRUE;
}

-(bool) proofMatrixDimensions
{
    NSUInteger arrayLength = [_data count];
    if (arrayLength != _numberOfRows * _numberOfColumns){
        NSLog(@"Fosser error: The imported matrix does not match the expected matrix dimensions.");
        return FALSE;
    }
    return TRUE;
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
