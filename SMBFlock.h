/* ######################################################################
* File Name: SMBFlock.h
* Project: Fossa
* Version: 19.05
* Creation Date: 19.05.2019
* Created By: Sebastian Malkusch
* Contact: <malkusch@chemie.uni-frankfurt.de>
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
*
* License
* Copyright (C) 2018  Sebastian Malkusch
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
#####################################################################*/

#ifndef SMBFlock_h
#define SMBFlock_h

#import <Foundation/Foundation.h>
#import "SMBActions.h"
#import "SMBDataFrame.h"
#import "SMBFileNames.h"
#import "SMBMatrix.h"
#import "SMBModelImporter.h"
#import "SMBNumericVector.h"
#import "SMBCharacterVector.h"

@interface SMBFlock : NSObject
{
	double _tmax;
	double _t;
    NSUInteger _seed;
    double _r1;
    double _r2;
    NSUInteger _reactionIndex;
	SMBDataFrame* _data;
    SMBCharacterVector* _species;
    SMBCharacterVector* _transitions;
	SMBNumericVector* _reactionConstants;
    SMBNumericVector* _reactionPDF;
    SMBNumericVector* _reactionCDF;
	SMBNumericVector* _stateVector;
	SMBMatrix* _eductMatrix;
	SMBMatrix* _productMatrix;
	SMBActions* _actions;
	SMBFileNames* _fileNames;
}

//initializers
-(id) init;

//import functions
-(void) parseArguments:(double) tValue :(NSUInteger) sValue :(NSString*) fileName;
-(bool) importModel;

//search functions
-(NSUInteger) binarySearchCDF:(double) data;

// simulation functions
-(void) initActions;
-(void) claculateReactionPDF;
-(void) calculateReactionCDF;
-(void) updateTimeStep;
-(void) updateStateVectorByReactionIndex;
-(NSUInteger) estimateReactionType;

//-(void) initMolecules;
-(void) runSimulation;

//proof functions
//-(bool) checkPDF;
//-(bool) checkProbability:(double) data;
-(bool) checkFlockValidity;
-(bool) checkEductMatrixValidity;

//write functions
-(void) logSimulation;
//-(void) writeSimulationParameterToFile:(NSMutableString*) data;
//-(void) writeSimulationResultToFile:(NSMutableString*) data;
//-(void) writeSimulationStatisticsToFile:(NSMutableString*) data;
//-(void) writeSimulationHistogramToFile:(NSMutableString*) data;

//print functions
-(void) printFlock;
//-(void) printMolecules;
//-(void) printProbabilityError:(double) data;
//-(void) printPDFError;

//deallocator
-(void) dealloc;
@end
#endif
