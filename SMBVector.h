/* ######################################################################
 * File Name: SMBVector.h
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

#ifndef SMBVector_h
#define SMBVector_h

@interface SMBVector : NSObject
{
    NSUInteger _numberOfEntries;
    NSMutableArray* _data;
}

//initializor
-(id)init;

//properties
-(NSUInteger) numberOfEntries;
-(void) setNumberOfEntries:(NSUInteger) value;
-(NSMutableArray*) data;
-(void) setData:(NSMutableArray*) dataArray;

//mutators
-(void) calculateNumberOfEntries;

//proof functions
-(bool) proofVectorDimension;
-(bool) proofIfEntryExists:(NSUInteger) idx;

//print Methods
-(void) printVector;
-(NSMutableString*) vectorString;

//deallocator
-(void) dealloc;

@end

#endif /* SMBVector_h */
