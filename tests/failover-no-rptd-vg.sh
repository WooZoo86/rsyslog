#!/bin/bash
# This file is part of the rsyslog project, released under GPLv3

uname
if [ `uname` = "FreeBSD" ] ; then
   echo "This test currently does not work on FreeBSD."
   exit 77
fi

echo ===============================================================================
echo \[failover-no-rptd.sh\]: rptd test for failover functionality - no failover
. $srcdir/diag.sh init
. $srcdir/diag.sh startup-vg failover-no-rptd.conf
. $srcdir/diag.sh injectmsg  0 5000
echo doing shutdown
. $srcdir/diag.sh shutdown-when-empty
echo wait on shutdown
. $srcdir/diag.sh wait-shutdown-vg
. $srcdir/diag.sh check-exit-vg
# now we need our custom logic to see if the result file is empty
# (what it should be!)
cmp rsyslog.out.log /dev/null
if [ $? -eq 1 ]
then
	echo "ERROR, output file not empty"
	exit 1
fi
. $srcdir/diag.sh exit
