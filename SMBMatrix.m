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
-(id) init :(unsigned int) columnNumber :(unsigned int) rowNumber
{
    self=[super init];
    if(self){
        _numberOfColumns = columnNumber;
        _numberOfRows = rowNumber;
        _data = [[NSMutableArray alloc] init];
        _error = nil;
    }
    return self;
}

//Properties
-(void) setNumberOfColumns:(unsigned int)columnNumber
{
    _numberOfColumns = columnNumber;
}

-(unsigned int) numberOfColumns
{
    return _numberOfColumns;
}

-(void) setNumberOfRows:(unsigned int)rowNumber
{
    _numberOfRows = rowNumber;
}

-(unsigned int) numberOfRows
{
    return _numberOfRows;
}

-(NSMutableArray*) data
{
    return _data;
}

//load functions
-(void) readCsv:(NSString *)fileName
{
    //define character for comments
    NSString* commentChar = @"#";
    //free _data
    [_data removeAllObjects];
    //load file to string
    NSString* rawFileContent = [NSString stringWithContentsOfFile: fileName
                                                  encoding:NSUTF8StringEncoding
                                                     error:&_error];
    if(_error != nil){
        [self printError];
        exit(1);
    }
    //convert string contents to NSNumber
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSArray* rows = [rawFileContent componentsSeparatedByString:@"\n"];
    for(NSString* row in rows){
        NSArray* columns = [row componentsSeparatedByString:@","];
        NSRange range = [[columns objectAtIndex:0] rangeOfString:commentChar];
        if(range.location == NSNotFound){
            for(NSString* stringEntry in columns){
                NSNumber* numberEntry = [formatter numberFromString:stringEntry];
                if(numberEntry != nil){
                    [_data addObject: numberEntry];
                }
            }
        }
    }
    [self proofMatrixDimensions];
}

-(bool) proofMatrixDimensions
{
    unsigned long arrayLength = [_data count];
    if (arrayLength != _numberOfRows * _numberOfColumns){
        NSLog(@"Fosser error: The imported matrix does not match the expected matrix dimensions.");
        exit(1);
        return FALSE;
    }
    return TRUE;
}
//print Methods
-(void) printMatrix
{
    NSMutableString* message = [[NSMutableString alloc] init];
    [message appendString:@"\n"];
    for (unsigned int i=0; i<_numberOfRows; i++){
        for(unsigned int j=0; j<_numberOfColumns; j++){
            [message appendFormat:@"%i\t", [[_data objectAtIndex: (i*_numberOfColumns+j)] intValue]];
        }
        [message appendString:@"\n"];
    }
    NSLog(@"%@", message);
}

-(void) printError{
    NSLog(@"Fossa detected an error:\n%@", _error);
}

//deallocator
-(void) dealloc
{
    NSLog(@"Matrix deallocated");
    [_data release];
    _data = nil;
    [_error release];
    _error = nil;
    [super dealloc];
}
@end
