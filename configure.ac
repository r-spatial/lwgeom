dnl Process this file with autoconf to produce a configure script.
dnl GDAL stuff largely copied from rgdal, (c) Roger Bivand
AC_INIT(src/lwgeom.cpp)

: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi

RBIN="${R_HOME}/bin/R"

# pick all flags for testing from R
: ${CC=`"${RBIN}" CMD config CC`}
: ${CXX=`"${RBIN}" CMD config CXX`}
: ${CPP=`"${RBIN}" CMD config CPP`}
: ${CFLAGS=`"${RBIN}" CMD config CFLAGS`}
: ${CPPFLAGS=`"${RBIN}" CMD config CPPFLAGS`}
: ${LDFLAGS=`"${RBIN}" CMD config LDFLAGS`}
# AC_SUBST([CC],["clang"])
# AC_SUBST([CXX],["clang++"])
AC_MSG_NOTICE([CC: ${CC}])
AC_MSG_NOTICE([CXX: ${CXX}])

#
# liblwgeom
#
AC_ARG_WITH([lwgeom],
  [AS_HELP_STRING([--without-lwgeom],
    [disable support for lwgeom])],
  [],
  [with_lwgeom=yes])

if test "x$with_lwgeom" != xno; then
 AC_CHECK_HEADERS(liblwgeom.h,,with_lwgeom=no)
 if test "${with_lwgeom}" = no; then
   AC_MSG_NOTICE([liblwgeom.h not found.])
 else
  LIBLWGEOM=
  AS_IF([test "x$with_lwgeom" != xno],
   [AC_CHECK_LIB([lwgeom], [lwgeom_version],
     [AC_SUBST([PKG_LIBS], ["${PKG_LIBS} -llwgeom"])
      AC_SUBST([PKG_CPPFLAGS], ["${PKG_CPPFLAGS} -DHAVE_LWGEOM"])
     ],
     [AC_MSG_NOTICE(
        [lwgeom was not found; on ubuntu, try: sudo apt-get install liblwgeom-dev])],
     [])])
 fi
fi

#
# concluding substitution
#
AC_MSG_NOTICE([Package CPP flags: ${PKG_CPPFLAGS}])
AC_MSG_NOTICE([Package LIBS: ${PKG_LIBS}])

AC_CONFIG_FILES(src/Makevars)
AC_OUTPUT
