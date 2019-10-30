GNUSTEP_MAKEFILES = /usr/share/GNUstep/Makefiles
CC = gcc

include $(GNUSTEP_MAKEFILES)/common.make


TOOL_NAME = fossa_cli
$(TOOL_NAME)_OBJCFLAGS = -std=gnu11
$(TOOL_NAME)_OBJCFLAGS += -O2
$(TOOL_NAME)_HEADERS = SMBActions.h
$(TOOL_NAME)_HEADERS += SMBCharacterVector.h
$(TOOL_NAME)_HEADERS += SMBDataFrame.h
$(TOOL_NAME)_HEADERS += SMBFileNames.h
$(TOOL_NAME)_HEADERS += SMBFlock.h
$(TOOL_NAME)_HEADERS += SMBMatrix.h
$(TOOL_NAME)_HEADERS += SMBModelImporter.h
$(TOOL_NAME)_HEADERS += SMBNumericVector.h
$(TOOL_NAME)_HEADERS += SMBParser.h
$(TOOL_NAME)_HEADERS += SMBVector.h
$(TOOL_NAME)_OBJC_FILES = main.m
$(TOOL_NAME)_OBJC_FILES += SMBActions.m
$(TOOL_NAME)_OBJC_FILES += SMBCharacterVector.m
$(TOOL_NAME)_OBJC_FILES += SMBDataFrame.m
$(TOOL_NAME)_OBJC_FILES += SMBFileNames.m
$(TOOL_NAME)_OBJC_FILES += SMBFlock.m
$(TOOL_NAME)_OBJC_FILES += SMBMatrix.m
$(TOOL_NAME)_OBJC_FILES += SMBModelImporter.m
$(TOOL_NAME)_OBJC_FILES += SMBNumericVector.m
$(TOOL_NAME)_OBJC_FILES += SMBParser.m
$(TOOL_NAME)_OBJC_FILES += SMBVector.m
#$(TOOL_NAME)_RESOURCE_FILES =

include $(GNUSTEP_MAKEFILES)/tool.make


