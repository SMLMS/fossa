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
#import "SMBModelImporter.h"
#import "SMBVector.h"

int main(int argc, const char * argv[]) {
    // set up manual reference counting (MRC) environment
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSMutableString* fileName =[[[NSMutableString alloc] init] autorelease];
    [fileName appendString:@"/home/malkusch/Dokumente/fossaTest/model.txt"];

    SMBModelImporter* mi = [[[SMBModelImporter alloc] init] autorelease];
    SMBVector* amountVector = [[[SMBVector alloc] init] autorelease];
    SMBVector* reactionConstants = [[[SMBVector alloc] init] autorelease];
    SMBMatrix* eductMatrix = [[[SMBMatrix alloc] init] autorelease];
    SMBMatrix* productMatrix = [[[SMBMatrix alloc] init] autorelease];

    [mi setFileName: fileName];
    if(![mi proofIfFileName]){
        [pool drain];
        return EXIT_FAILURE;
    }

    [mi readCsv];
    @try{
        [amountVector setData: [mi subModelFrom:@"* start" to:@"* stop"]];
        [amountVector calculateNumberOfEntries];
        [reactionConstants setData: [mi subModelFrom:@"§ start" to:@"§ stop"]];
        [reactionConstants calculateNumberOfEntries];
        [eductMatrix setNumberOfColumns: [reactionConstants numberOfEntries]];
        [eductMatrix setNumberOfRows: [amountVector numberOfEntries]];
        [productMatrix setNumberOfColumns: [reactionConstants numberOfEntries]];
        [productMatrix setNumberOfRows: [amountVector numberOfEntries]];
        [eductMatrix setData: [mi subModelFrom:@"$ start" to:@"$ stop"]];
        [productMatrix setData: [mi subModelFrom:@"# start" to:@"# stop"]];
    }
    @catch(NSException* exception){
        NSLog(@"Fossa caught an exception:\n %@", exception);
        [pool drain];
        return EXIT_FAILURE;
    }
    [amountVector printVectorAsInt];
    [reactionConstants printVectorAsFloat];
    if([eductMatrix proofMatrixDimensions]){
        [eductMatrix printMatrix];
    }
    if([productMatrix proofMatrixDimensions]){
        [productMatrix printMatrix];
    }
    [pool drain];
    return EXIT_SUCCESS;
}
