# -*- Makefile

CXXFLAGS+=-g -std=c++17 -Wall -Wextra
LD=g++
LIB=-luriparser
OBJ=$(SRC:.cpp=.o)
SOBJ=$(PACKSODIR)/uriparser.$(SOEXT)
SRC=$(wildcard cpp/*.cpp)

.PHONY: check clean distclean install

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)
	$(LD) $(ARCH) $(LDSOFLAGS) -o $@ $^ $(LIB) $(SWISOLIB)

cpp/%.o: cpp/%.cpp
	$(CXX) $(ARCH) $(CFLAGS) $(CXXFLAGS) -c -o $@ $<

all: $(SOBJ)

check::
	$(SWIPL) -s test/test_uriparser.pl -g run_tests -t halt

clean:
	$(RM) $(OBJ)

distclean:
	$(RM) $(OBJ) $(SOBJ)

install::
