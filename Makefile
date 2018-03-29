# -*- Makefile

CFLAGS+=-c -g -std=c++17 -Wall -Wextra
ld=g++
libs=-luriparser
obj=$(src:.cpp=.o)
rm=rm -f
sobj=$(PACKSODIR)/uriparser.$(SOEXT)
src=$(wildcard cpp/*.cpp)

all:	$(sobj)

$(sobj): $(obj)
	mkdir -p $(PACKSODIR)
	$(ld) $(ARCH) $(LDSOFLAGS) -o $@ $^ $(libs) $(SWISOLIB)

cpp/%.o: cpp/%.cpp
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

check::
install::
clean:
	$(rm) $(sobj) $(obj)

distclean:
	$(rm) $(sobj) $(obj)
