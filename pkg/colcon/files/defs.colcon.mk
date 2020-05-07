# Makefile fragment for defs.colcon.mk
#
# Copyright (c) 2020 Wind River Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# modification history
# --------------------
# 06may20,akh created
#

ifeq ($(__colcon_defs),)
__colcon_defs = TRUE

define unpack_repos
	$(ECHO) "Unpacking repos $1" ; \
	case "$(PKG_FILE_NAME)" in \
	  *.repos) \
	    mkdir -p $(BUILD_DIR)/$(1)/$(PKG_BUILD_DIR)/src; \
	    cd $(BUILD_DIR)/$(1)/$(PKG_BUILD_DIR); \
	    vcs import src < $(DOWNLOADS_DIR)/$(PKG_FILE_NAME) ;; \
	esac
endef

define patch_repos
        for pn in $(1); do \
	        N=$$(basename $$pn); \
                if ls $(BUILD_DIR)/$(PKG_NAME)/$(2)/$$N/usr_src/0001-* 1> /dev/null 2>&1; then \
                        PATCHES="$(BUILD_DIR)/$(PKG_NAME)/$(2)/$$N/usr_src/*.patch"; \
                        for PATCH in $$PATCHES; do \
                                cd $(BUILD_DIR)/$(PKG_NAME)/$(PKG_BUILD_DIR)/src/$$pn ; \
                                $(PATCH) -p1 < $$PATCH ; \
                        done; \
                fi \
	done;
endef

define ignore_repos
	for i in $(1); do \
		touch $(BUILD_DIR)/$(PKG_NAME)/$(PKG_BUILD_DIR)/src/$$i/COLCON_IGNORE; \
	done;
endef
endif
