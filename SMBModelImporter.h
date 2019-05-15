/* ######################################################################
 * File Name: SMBModelImporter.h
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

#ifndef SMBModelImporter_h
#define SMBModelImporter_h

@interface SMBModelImporter : NSObject
{
    NSString* _fileName;
    NSString* _data;
}

//initializor
-(id)init;
-(id)initWithFileName:(NSString*) value;

//properties
-(NSString*) fileName;
-(void) setFileName:(NSString*) value;
-(NSString*) _data;

//mutators
-(NSMutableArray*) subModelFrom:(NSString*) startSeq to:(NSString*) stopSeq;

//load functions
-(void) readCsv;

//proof functions
-(bool) proofIfFileName;
-(bool) proofIfFileExists;

//print Methods
-(void) printFileName;
-(void) printData;

//deallocator
-(void) dealloc;

@end

#endif /* SMBModelImporter_h */
