/* ######################################################################
 * File Name: SMBNumericVector.h
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

#ifndef SMBNumericVector_h
#define SMBNumericVector_h
#import "SMBVector.h"

@interface SMBNumericVector : SMBVector
{
    
}
//initializor
-(id)initWithSize:(NSUInteger) value;

//mutators
-(NSNumber*) objectAtIndex:(NSUInteger) idx;
-(void) replaceObjectAtIndex:(NSUInteger) idx with:(NSNumber*) object;

//print Methods
/*
-(void) printVectorAsInt;
-(void) printVectorAsFloat;
-(void) printVectorAsScientific;
 */

@end
#endif /* SMBNumericVector_h */
