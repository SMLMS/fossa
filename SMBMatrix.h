/* ######################################################################
 * File Name: SMBMatrix.h
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


#ifndef SMBMatrix_h
#define SMBMatrix_h

@interface SMBMatrix : NSObject
{
    NSUInteger _numberOfColumns;
    NSUInteger _numberOfRows;
    NSMutableArray* _data;
}

//initializor
-(id) init:(NSUInteger) columnNumber :(NSUInteger) rowNumber;

//properties
-(void) setNumberOfColumns: (NSUInteger) columnNumber;
-(NSUInteger) numberOfColumns;
-(void) setNumberOfRows:(NSUInteger) rowNumber;
-(NSUInteger) numberOfRows;
-(NSMutableArray*) data;

//load functions
-(bool) readCsv: (NSString*) startCharacter :(NSString*) stopCharacter :(NSString*) fileName;

//proof functions
-(bool) proofMatrixDimensions;

//print Methods
-(void) printMatrix;

//deallocator
-(void) dealloc;
@end

#endif /* SMBMatrix_h */
