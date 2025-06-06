# File: qeWidgetDisplayApp/project/QEWidgetDisplayApp.pro
# DateTime: Mon May 26 17:14:10 2025
# Last checked in by: starritt
#
# This file is part of the EPICS QT Framework, initially developed at the Australian Synchrotron.
#
# The EPICS QT Framework is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The EPICS QT Framework is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with the EPICS QT Framework.  If not, see <http://www.gnu.org/licenses/>.
#
#  Copyright (c) 2014,2016 Australian Synchrotron
#
#  Author:
#    Andrew Rhyder
#  Contact details:
#    andrew.rhyder@synchrotron.org.au
#

#
# Simple GUI application to demonstrate programatically adding QE widgets to a user interface
#

# Points to the target directoy in which bin/EPICS_HOST_ARCH/qegui
# will be created. This follows the regular EPICS Makefile paradigm.
#
TOP=../..

message ("QT_VERSION = "$$QT_MAJOR_VERSION"."$$QT_MINOR_VERSION"."$$QT_PATCH_VERSION )

QT       += core gui xml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = QEWidgetDisplay
TEMPLATE = app

# Determine EPICS_BASE
_EPICS_BASE = $$(EPICS_BASE)

# Check EPICS dependancies
isEmpty( _EPICS_BASE ) {
    error( "EPICS_BASE must be defined. Ensure EPICS is installed and EPICS_BASE environment variable is defined." )
}

_EPICS_HOST_ARCH = $$(EPICS_HOST_ARCH)
isEmpty( _EPICS_HOST_ARCH ) {
    error( "EPICS_HOST_ARCH must be defined. Ensure EPICS is installed and EPICS_HOST_ARCH environment variable is defined." )
}

# Determine QE framework library
#
_QE_FRAMEWORK = $$(QE_FRAMEWORK)
isEmpty( _QE_FRAMEWORK ) {
    error( "QE_FRAMEWORK must be defined. Ensure EPICS is installed and EPICS_HOST_ARCH environment variable is defined." )
}

# Install the generated plugin library and include files in QE_TARGET_DIR if defined.
_QE_TARGET_DIR = $$(QE_TARGET_DIR)
isEmpty( _QE_TARGET_DIR ) {
    INSTALL_DIR = $$TOP
    message( "QE_TARGET_DIR is not defined. The QE GUI application will be installed into the <top> directory." )
} else {
    INSTALL_DIR = $$(QE_TARGET_DIR)
    message( "QE_TARGET_DIR is defined. The QE GUI application will be installed directly into" $$INSTALL_DIR )
}

# The APPLICATION ends up here.
#
DESTDIR = $$INSTALL_DIR/bin/$$(EPICS_HOST_ARCH)

# Place all intermediate generated files in architecture specific locations
#
MOC_DIR        = O.$$(EPICS_HOST_ARCH)/moc
OBJECTS_DIR    = O.$$(EPICS_HOST_ARCH)/obj
UI_DIR         = O.$$(EPICS_HOST_ARCH)/ui
RCC_DIR        = O.$$(EPICS_HOST_ARCH)/rcc
MAKEFILE       = Makefile.$$(EPICS_HOST_ARCH)

# We don't get this include path for free - need to be explicit.
#
INCLUDEPATH += O.$$(EPICS_HOST_ARCH)/ui

SOURCES += main.cpp\
        mainwindow.cpp

HEADERS  += mainwindow.h

FORMS    += mainwindow.ui \
    QEWidgetDisplayDialog.ui

INCLUDEPATH += . \
    ./include

RESOURCES += \
    resources.qrc


# Include header files from the QE framework
#
INCLUDEPATH += $$(QE_FRAMEWORK)/include

LIBS += -L$$(EPICS_BASE)/lib/$$(EPICS_HOST_ARCH) -lca -lCom

# Set run time path for shared libraries
#
unix: QMAKE_LFLAGS += -Wl,-rpath,$$(EPICS_BASE)/lib/$$(EPICS_HOST_ARCH)

LIBS += -L$$(QE_FRAMEWORK)/lib/$$(EPICS_HOST_ARCH) -lQEFramework
unix: QMAKE_LFLAGS += -Wl,-rpath,$$(QE_FRAMEWORK)/lib/$$(EPICS_HOST_ARCH)

# end
