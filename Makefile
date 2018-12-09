# -*- Makefile

CXXFLAGS+=-g -std=c++17 -Wall -Wextra
LD=g++
LIB=-luriparser
OBJ=$(SRC:.cpp=.o)
SOBJ=$(PACKSODIR)/uriparser.$(SOEXT)
SRC=$(wildcard cpp/*.cpp)

.PHONY: check clean distclean install

all:	$(SOBJ)

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)
	$(LD) $(ARCH) $(LDSOFLAGS) -o $@ $^ $(LIBS) $(SWISOLIB)

cpp/%.o: cpp/%.cpp
	$(CXX) $(ARCH) $(CFLAGS) $(CXXFLAGS) -c -o $@ $<

clean:
distclean:
	$(RM) $(SOBJ) $(OBJ)

check::
install::
