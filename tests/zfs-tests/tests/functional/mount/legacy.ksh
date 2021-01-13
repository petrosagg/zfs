#!/bin/ksh -p
#
# CDDL HEADER START
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#
# CDDL HEADER END
#

#
# Copyright (c) 2017 Datto, Inc. All rights reserved.
#

. $STF_SUITE/include/libtest.shlib

#
# DESCRIPTION:
# zfs datasets should be mountable with mount(8) if their mountpoint is set to legacy. mount.zfs
#
# STRATEGY:
# 1. Set dataset mountpoints to legacy
# 2. Attempt to mount it with mount(8) in various ways
# 3. Unmount everything
#

for i in 1 2 3; do
	dir=$TESTDIR.$i
	fs=$TESTPOOL/$TESTFS.$i
	log_must zfs set mountpoint=legacy $fs
done

# Test normal mount
log_must mount -t zfs $TESTPOOL/$TESTFS.1 $dir

# Test mount helper with normal path
log_must mount.zfs $TESTPOOL/$TESTFS.2 $dir

# Test mount helper with canonicalized path
log_must mount.zfs /$TESTPOOL/$TESTFS.3 $dir

for i in 1 2 3; do
	dir=$TESTDIR.$i
	log_must umount $dir
done

log_pass "legacy datasets are mountable with mount(8)"
