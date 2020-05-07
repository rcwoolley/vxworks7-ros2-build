# Makefile - for ros2
#
# Copyright (c) 2019 Wind River Systems, Inc.
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
# 15nov19,rcw  created
# 12mar18,akh  created
#

# SYNOPSIS        automate the build of ROS2
include $(WIND_USR_MK)/defs.common.mk
include $(WIND_USR_MK)/defs.packages.mk
include $(WIND_USR_MK)/defs.crossbuild.mk
include $(3PP_USR_MK)/defs.colcon.mk
include $(PACKAGE_DIR)/ros2/packages.mk

PACKAGES += ros2

PKG_NAME = ros2
PKG_VER =  dashing

PKG_FILE_NAME=${PKG_NAME}.repos
PKG_COMMIT_ID = master
PKG_URL = https://raw.githubusercontent.com/ros2/ros2/${PKG_COMMIT_ID}/${PKG_FILE_NAME}
# custom pkg type
PKG_TYPE = repos

PKG_URL2 = https://github.com/Wind-River/vxworks7-layer-for-ros2.git
PKG_COMMIT_ID2 = foxy-SR0640
PKG_SRC_DIR2 = patches

PKG_LICENSE = BSD

PKG_BUILD_DIR = ros2_ws
# ros2.download
PKG_DOWNLOAD = fetch_archive
# ros2.unpack
PKG_UNPACK = unpack_repos

PKG_BUILD_TYPE := Debug

ros2.patch: ros2.unpack
	@$(call echo_action,Patching,$*)
	@$(MAKE_STAMP)

#	$(call fetch_git,$(PKG_NAME),$(PKG_URL2))
#	$(call clone_git,$(PKG_NAME),$(PKG_URL2),$(PKG_COMMIT_ID2),$(PKG_SRC_DIR2))
#	$(call patch_repos,$(ROS2_PATCH_DIRS),$(PKG_SRC_DIR2))

ros2.configure: ros2.patch
	@$(call echo_action,Configuring,$*)
	$(call ignore_repos,$(ROS_IGNORE_DIRS))
	@$(call echo_action,Installing build dependencies,$*)
	pip3 install numpy;
	pip3 install lark-parser;
	@$(MAKE_STAMP)

ros2.build: ros2.configure
	@$(call echo_action,Building,$*)
	cd $(BUILD_DIR)/$(PKG_NAME)/$(PKG_BUILD_DIR); \
	export PATH=$(3PP_HOST_DIR)/bin:$(PATH); \
	export PYTHONPATH=$(3PP_HOST_DIR)/lib/python3.8/site-packages:$(PYTHONPATH); \
	colcon build --merge-install --cmake-force-configure --packages-up-to $(PKG_PKGS_UP_TO) \
		--cmake-args \
                -DCMAKE_BUILD_TYPE:STRING=$(PKG_BUILD_TYPE) \
                -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
		-DCMAKE_PREFIX_PATH=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_BUILD_DIR)/install \
		-DCMAKE_TOOLCHAIN_FILE=$(TGT_CMAKE_TOOLCHAIN_FILE) \
		-DPYTHON_SOABI=cpython-38-vxworks \
                -DBUILD_TESTING:BOOL=OFF
	@$(MAKE_STAMP)

ros2.install : ros2.build
	@$(call echo_action,Installing run-time dependencies,$*)
	pip3 install --ignore-installed --prefix=$(WIND_CC_SYSROOT)/usr/3pp/develop/usr setuptools
	pip3 install --ignore-installed --prefix=$(WIND_CC_SYSROOT)/usr/3pp/develop/usr catkin_pkg
	@$(call echo_action,Installing,$*)
	@# copy PRJ libs and binaries to VSB
	cd $(BUILD_DIR)/$(PKG_NAME)/$(PKG_BUILD_DIR) && \
	if [ -d install ]; then \
		find install -name *.so* -exec install -m 644 {} $(ROOT_DIR)/lib/ \;; \
		find install -name *.vxe -exec install -m 644 {} $(ROOT_DIR)/$(TOOL)/bin/ \;; \
		find install -name *.urdf -exec install -m 755 {} $(ROOT_DIR)/$(TOOL)/bin/ \;; \
	fi
	@$(MAKE_STAMP)

include $(WIND_USR_MK)/rules.packages.mk

