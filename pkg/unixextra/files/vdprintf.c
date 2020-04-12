/* vdprintf.c - vdprintf implementaion extensions for UNIX compatibility */

/*
 * Copyright (c) 2020 Wind River Systems, Inc.
 *
 * The right to copy, distribute, modify, or otherwise make use of this software
 * may be licensed only pursuant to the terms of an applicable Wind River
 * license agreement.
 */

/*
modification history
--------------------
14mar20, akh  created
*/

#include <stdarg.h>

int (vdprintf)(int fd, const char * fmt,
	va_list ap)
        {       /* print formatted to a file descriptor from arg list */
        return (0); /* nothing is printed at the moment*/
	}
