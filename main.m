/* ######################################################################
* File Name: main.m
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
#import "SMBVector.h"

int main(int argc, const char * argv[]) {
    // set up manual reference counting (MRC) environment
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSMutableString* fileName =[[[NSMutableString alloc] init] autorelease];
    [fileName appendString:@"/Users/malkusch/Documents/Biophysik/fossa/model.txt"];
    SMBVector* amountVector = [[[SMBVector alloc] init] autorelease];
    SMBVector* reactionConstants = [[[SMBVector alloc] init] autorelease];
    SMBMatrix* eductMatrix = [[[SMBMatrix alloc] init:4 :3] autorelease];
    SMBMatrix* productMatrix = [[[SMBMatrix alloc] init:4 :3] autorelease];

    @try{
        [amountVector readCsv:@"*" :fileName];
    }
    @catch(NSException* exception){
        NSLog(@"Fossa caught an exception:\n %@", exception);
        [pool drain];
        return 1;
    }
    @try{
        [reactionConstants readCsv:@"§" :fileName];
    }
    @catch(NSException* exception){
        NSLog(@"Fossa caught an exception:\n %@", exception);
        [pool drain];
        return 1;
    }
    @try{
        [eductMatrix readCsv:@"$" : @"%" :fileName];
    }
    @catch(NSException* exception){
        NSLog(@"Fossa caught an exception:\n %@", exception);
        [pool drain];
        return 1;
    }
    if(![eductMatrix proofMatrixDimensions]){
        [pool drain];
        return 1;
    }
    @try{
        [productMatrix readCsv:@"%" :@"&" :fileName];
    }
    @catch(NSException* exception){
        NSLog(@"Fossa caught an exception:\n %@", exception);
        [pool drain];
        return 1;
    }
    if(![productMatrix proofMatrixDimensions]){
        [pool drain];
        return 1;
    }
    NSNumber* num = [[NSNumber alloc] initWithInt:5];
    @try{
        [eductMatrix replaceObjectAtIndex:0 :0 with:num];
        //NSLog(@"The value is %@", [eductMatrix objectAtIndex:0 :3]);
    }
    @catch(NSException* exception){
        NSLog(@"Fossa caught an exception:\n %@", exception);
        [pool drain];
        return 1;
    }
    [amountVector printVectorAsInt];
    [reactionConstants printVectorAsFloat];
    [eductMatrix printMatrix];
    [productMatrix printMatrix];
    [pool drain];
    return 0;
}
