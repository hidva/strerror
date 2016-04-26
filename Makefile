TARNAME := strerror
BIN := strerror

C_SRC :=
CXX_SRC := main.cc
CFLAGS :=   -Wall -O2
CXXFLAGS :=  -std=c++11 -Wall -O2

LDFLAGS := 
# 安装路径的前缀.
PREFIX := /usr

####### 以下不需要配置 ###############
OBJ_DIR := objs
DEP_DIR := $(OBJ_DIR)/deps
BIN_DIR := bin
DISTDIR := $(OBJ_DIR)/$(TARNAME).tar.gz.tmp.dir
CWD_FULLPATH := $(shell pwd)

C_OBJS := $(C_SRC:.c=.c.o)
CXX_OBJS := $(CXX_SRC:.cc=.cc.o)
ALL_DEPS := $(C_OBJS:.o=.dep)
ALL_DEPS += $(CXX_OBJS:.o=.dep)

C_OBJS := $(foreach var,$(C_OBJS),$(OBJ_DIR)/$(var))
CXX_OBJS := $(foreach var,$(CXX_OBJS),$(OBJ_DIR)/$(var))
ALL_DEPS := $(foreach var,$(ALL_DEPS),$(DEP_DIR)/$(var))

all: $(BIN_DIR)/$(BIN)
	

include $(ALL_DEPS)

$(DEP_DIR)/%.c.dep: %.c
	@if [ ! -d $(dir $@) ] ; then mkdir -pv $(dir $@); fi
	gcc -E -M -MQ $(OBJ_DIR)/$*.c.o -MQ $@ -MF $@ $< $(CFLAGS)
	
$(DEP_DIR)/%.cc.dep: %.cc
	@if [ ! -d $(dir $@) ] ; then mkdir -pv $(dir $@); fi
	gcc -E -M -MQ $(OBJ_DIR)/$*.cc.o -MQ $@ -MF $@ $< $(CXXFLAGS)
	
$(OBJ_DIR)/%.c.o: %.c 
	@if [ ! -d $(dir $@) ] ; then mkdir -pv $(dir $@); fi
	gcc -c $< -o $@ $(CFLAGS)

$(OBJ_DIR)/%.cc.o: %.cc 
	@if [ ! -d $(dir $@) ] ; then mkdir -pv $(dir $@); fi
	g++ -c $< -o $@ $(CXXFLAGS)

$(BIN_DIR)/$(BIN): $(C_OBJS) $(CXX_OBJS) 
	@if [ ! -d $(BIN_DIR) ] ; then mkdir -pv $(BIN_DIR); fi
ifeq ($(strip $(CXX_SRC)),)
	gcc -o $(BIN_DIR)/$(BIN) $(C_OBJS) $(CXX_OBJS) $(LDFLAGS)
else
	g++ -o $(BIN_DIR)/$(BIN) $(C_OBJS) $(CXX_OBJS) $(LDFLAGS)
endif

clean:
	-@rm -v  $(ALL_DEPS) $(C_OBJS) $(CXX_OBJS) $(BIN_DIR)/$(BIN)

install:
	@mkdir -pv $(PREFIX)/bin
	@cp $(BIN_DIR)/$(BIN) $(PREFIX)/bin -v

.PHONY: all clean mkObjDir mkDepDir mkBinDir install $(DISTDIR)
 

dist: $(TARNAME).tar.gz

$(TARNAME).tar.gz: $(DISTDIR)
	cd $(DISTDIR); \
	tar czvf $(CWD_FULLPATH)/$(TARNAME).tar.gz .
	rm -rf $(DISTDIR)

$(DISTDIR):
	mkdir -p $(DISTDIR)
	git ls-files | xargs -L 1 dirname | sed -e 's|^|$(DISTDIR)/|' | xargs -L 1 mkdir -p
	git ls-files | sed -e 's|\(.*\)|\0 $(DISTDIR)/\0|' | xargs -L 1 cp
	-rm -f $(DISTDIR)/.git*
 
