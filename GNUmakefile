GNUSTEP_MAKEFILES = /usr/share/GNUstep/Makefiles
CC = gcc

include $(GNUSTEP_MAKEFILES)/common.make


TOOL_NAME = fossa_cli
$(TOOL_NAME)_OBJCFLAGS = -std=c99
$(TOOL_NAME)_HEADERS = SMBMatrix.h
$(TOOL_NAME)_HEADERS += SMBVector.h
$(TOOL_NAME)_OBJC_FILES = main.m
$(TOOL_NAME)_OBJC_FILES += SMBMatrix.m
$(TOOL_NAME)_OBJC_FILES += SMBVector.m
#$(TOOL_NAME)_RESOURCE_FILES =

include $(GNUSTEP_MAKEFILES)/tool.make


