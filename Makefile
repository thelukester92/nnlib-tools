# all       - make all tools
# clean     - remove build artifacts
# install   - install all tools to the bin folder
# uninstall - remove all installed files

NNLIB    := nnlib
CXXFLAGS := -Wall
PREFIX   := /usr/local

override CXXFLAGS += -std=c++11
override OPTFLAGS := $(CXXFLAGS) -O3
override DBGFLAGS := $(CXXFLAGS) -O0 -g
override DEPFILES := $(shell find src -name "*.cpp")
override DEPFILES := $(DEPFILES:src/%.cpp=obj/%.d) $(DEPFILES:src/%.cpp=obj/dbg/%.d)
override APPS     := csvtobin
override APPS     := $(APPS:%=bin/%) $(APPS:%=bin/%_dbg)
override INSTALL  := $(APPS:bin/%=$(PREFIX)/bin/nnlib_%)

all: $(APPS)
clean:
	rm -rf bin obj
install: $(INSTALL)
uninstall:
	rm -rf $(INSTALL)

bin/%: obj/%.o
	@mkdir -p $(dir $@)
	$(CXX) $< $(OPTFLAGS) $(LDFLAGS) -l$(NNLIB) -MMD -o $@

bin/%_dbg: obj/dbg/%.o
	@mkdir -p $(dir $@)
	$(CXX) $< $(DBGFLAGS) $(LDFLAGS) -l$(NNLIB)_dbg -MMD -o $@

obj/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $< $(OPTFLAGS) -c -MMD -o $@

obj/dbg/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $< $(DBGFLAGS) -c -MMD -o $@

$(PREFIX)/bin/nnlib_%: bin/%
	cp $< $@

.PHONY: all clean install uninstall

-include $(DEPFILES)
