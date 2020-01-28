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
: ${CFLAGS=`"${RBIN}" CMD config CFLAGS`}
: ${CPPFLAGS=`"${RBIN}" CMD config CPPFLAGS`}
: ${LDFLAGS=`"${RBIN}" CMD config LDFLAGS`}
# AC_SUBST([CC],["clang"])
# AC_SUBST([CXX],["clang++"])
AC_MSG_NOTICE([CC: ${CC}])
AC_MSG_NOTICE([CXX: ${CXX}])

#
# PROJ
#

PROJ_CONFIG="pkg-config proj"

if `$PROJ_CONFIG --exists` ; then
  AC_MSG_NOTICE([pkg-config proj exists, will use it])
  proj_config_ok=yes
else
  proj_config_ok=no
fi

AC_ARG_WITH([proj-include],
    AC_HELP_STRING([--with-proj-include=DIR],
                   [location of proj header files]),
    [proj_include_path=$withval])
if test [ -n "$proj_include_path" ] ; then
   AC_SUBST([PROJ_CPPFLAGS],["-I${proj_include_path}"])
else
  if test "${proj_config_ok}" = yes; then
    PROJ_INCLUDE_PATH=`${PROJ_CONFIG} --cflags`
    AC_SUBST([PROJ_CPPFLAGS],["${PROJ_INCLUDE_PATH}"])
  fi
fi

# honor PKG_xx overrides
# for CPPFLAGS we will superfluously double R's flags
# since we'll set PKG_CPPFLAGS with this, but that shouldn't hurt

#if test "${proj_config_ok}" = yes ; then
#else
  AC_CHECK_HEADERS(proj.h,,projh=no)
  if test "{projh}" = no ; then
    AC_CHECK_HEADERS(proj_api.h,,proj4ok=no)
    if test "{proj4ok}" = no ; then
      AC_MSG_ERROR([neither proj.h nor proj_api.h were found.])
	else
      PROJ_CPPFLAGS="$PROJ_CPPFLAGS -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"
	fi
  else
    PROJ_CPPFLAGS="$PROJ_CPPFLAGS -DHAVE_PROJ_H"
  fi
#fi

CPPFLAGS="${INCPPFLAGS} ${PKG_CPPFLAGS} ${PROJ_CPPFLAGS}"
PKG_CPPFLAGS="${PKG_CPPFLAGS} ${PROJ_CPPFLAGS}"

# dnl ditto for a library path
AC_ARG_WITH([proj-lib],
    AC_HELP_STRING([--with-proj-lib=LIB_PATH],
               [the location of proj libraries]),
               [proj_lib_path=$withval])
if test [ -n "$proj_lib_path" ] ; then
    AC_SUBST([PROJ_LIBS], ["-L${proj_lib_path} ${INPKG_LIBS} -lproj"])
else
  if test "${proj_config_ok}" = yes; then
    PROJ_LIB_PATH=`${PROJ_CONFIG} --libs`
    AC_SUBST([PROJ_LIBS], ["${PROJ_LIB_PATH} ${INPKG_LIBS}"])
	proj_version=`${PROJ_CONFIG} --modversion`
	AC_MSG_NOTICE([PROJ: ${proj_version}])
  else
    PROJ_LIBS="${PKG_LIBS} -lproj"
  fi
fi

PKG_LIBS="${PKG_LIBS} ${PROJ_LIBS}"
LIBS="${INLIBS} ${PKG_LIBS}"

[cat > proj_conf_test.c <<_EOCONF
#include <stdio.h>
#ifdef HAVE_PROJ_H
#include <proj.h>
int main() {
    printf("%d%d%d\n", PROJ_VERSION_MAJOR, PROJ_VERSION_MINOR, PROJ_VERSION_PATCH);
    return 0;
}
#else
#include <proj_api.h>
int main() {
    printf("%d\n", PJ_VERSION);
    return 0;
}
#endif
_EOCONF]

# AC_MSG_NOTICE([PKG_LIBS: ${PKG_LIBS}])

${CC} ${CFLAGS} ${CPPFLAGS} -o proj_conf_test proj_conf_test.c ${PROJ_LIBS}

proj_version=`./proj_conf_test`

# xxx
POSTGIS_PROJ_VERSION=`echo $proj_version | cut -c "1,2"`
AC_MSG_NOTICE([POSTGIS_PROJ_VERSION: ${POSTGIS_PROJ_VERSION}])
#AC_SUBST([POSTGIS_PROJ_VERSION],["${PROJV12}"])
#AC_DEFINE_UNQUOTED([POSTGIS_PROJ_VERSION], [$POSTGIS_PROJ_VERSION], [PROJ library version])
AC_SUBST(POSTGIS_PROJ_VERSION)

AC_ARG_WITH([proj-share],
    AC_HELP_STRING([--with-proj-share=SHARE_PATH],
               [the location of proj metadata files]),
               [proj_share_path=$withval])
if test [ -n "$proj_share_path" ] ; then
    AC_MSG_NOTICE([PROJ_LIB: ${proj_share_path}])
fi

#
# GEOS:
#
GEOS_CONFIG="geos-config"

GEOS_CONFIG_SET="no"

AC_ARG_WITH([geos-config],
    AC_HELP_STRING([--with-geos-config=GEOS_CONFIG],
           [the location of geos-config]),
           [geos_config=$withval])
if test [ -n "$geos_config" ] ; then
    GEOS_CONFIG_SET="yes"
    AC_SUBST([GEOS_CONFIG],["${geos_config}"])
    AC_MSG_NOTICE(geos-config set to $GEOS_CONFIG)
fi

if test ["$GEOS_CONFIG_SET" = "no"] ; then
  AC_PATH_PROG([GEOS_CONFIG], ["$GEOS_CONFIG"],["no"])
  if test ["$GEOS_CONFIG" = "no"] ; then
    AC_MSG_RESULT(no)
    AC_MSG_ERROR([geos-config not found or not executable.])
  fi
else
  AC_MSG_CHECKING(geos-config exists)
  if test -r "${GEOS_CONFIG}"; then
    AC_MSG_RESULT(yes)
  else
    AC_MSG_RESULT(no)
    AC_MSG_ERROR([geos-config not found - configure argument error.])
  fi
  AC_MSG_CHECKING(geos-config executable)
  if test -x "${GEOS_CONFIG}"; then
    AC_MSG_RESULT(yes)
  else
    AC_MSG_RESULT(no)
    AC_MSG_ERROR([geos-config not executable.])
  fi
fi

AC_MSG_CHECKING(geos-config usability)
if test `${GEOS_CONFIG} --version`
then
  GEOS_CLIBS=`${GEOS_CONFIG} --clibs`
  #GEOS_DEP_CLIBS=`geos-config --static-clibs` -- this gives -m instead of -lm, which breaks clang
  # fixed in 3.7.0 at https://github.com/libgeos/libgeos/pull/73#issuecomment-262208677
  GEOS_DEP_CLIBS=`${GEOS_CONFIG} --static-clibs | sed 's/-m/-lm/g'`
  GEOS_CPPFLAGS=`${GEOS_CONFIG} --cflags`
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
  AC_MSG_ERROR([${GEOS_CONFIG} not usable])
fi

GEOS_VERSION=`${GEOS_CONFIG} --version`
AC_MSG_NOTICE([GEOS: ${GEOS_VERSION}])
AC_MSG_CHECKING([GEOS version >= 3.3.0]) # GDAL 2.0.1 requires GEOS 3.1.0
GEOS_VER_DOT=`echo $GEOS_VERSION | tr -d "."`
if test ${GEOS_VER_DOT} -lt 330 ; then
  AC_MSG_RESULT(no)
  AC_MSG_ERROR([upgrade GEOS to 3.3.0 or later])
else
  AC_MSG_RESULT(yes)
fi

# honor PKG_xx overrides
# for CPPFLAGS we will superfluously double R's flags
# since we'll set PKG_CPPFLAGS with this, but that shouldn't hurt
PKG_CPPFLAGS="${PKG_CPPFLAGS} ${GEOS_CPPFLAGS}"
CPPFLAGS="${CPPFLAGS} ${PKG_CPPFLAGS}"
LIBS="${LIBS} ${PKG_LIBS} ${GEOS_CLIBS}"

if test ${GEOS_VER_DOT} -lt 350 ; then
  AC_SUBST([PKG_CPPFLAGS], ["${PKG_CPPFLAGS} -DPOSTGIS_GEOS_VERSION=34"])
else
  AC_SUBST([PKG_CPPFLAGS], ["${PKG_CPPFLAGS} -DPOSTGIS_GEOS_VERSION=35"])
  # 34 or 35 is all liblwgeom cares about, now
fi

geosok=yes
AC_CHECK_HEADERS(geos_c.h,,geosok=no)
if test "${geosok}" = no; then
   AC_MSG_ERROR([geos_c.h not found in given locations.])
fi

[cat > geos_test.cpp <<_EOCONF
#include <geos_c.h>
#ifdef __cplusplus
extern "C" {
#endif
static void __errorHandler(const char *fmt, ...) {
    return;
}
static void __warningHandler(const char *fmt, ...) {
    return;
}
int main() {
    GEOSContextHandle_t r = initGEOS_r((GEOSMessageHandler) __warningHandler, (GEOSMessageHandler) __errorHandler);
    finishGEOS_r(r);
}
#ifdef __cplusplus
}
#endif
_EOCONF]

#echo "${CXX} ${CPPFLAGS} -o geos_test geos_test.cpp ${LIBS}"
AC_MSG_CHECKING(geos: linking with ${GEOS_CLIBS})
${CXX} ${CPPFLAGS} -o geos_test geos_test.cpp ${GEOS_CLIBS} 2> errors.txt
if test `echo $?` -ne 0 ; then
 geosok=no
 AC_MSG_RESULT(no)
else
 AC_SUBST([GEOS_LIBS], ["${GEOS_CLIBS}"])
 AC_MSG_RESULT(yes)
fi

if test "${geosok}" = no; then
  AC_MSG_CHECKING(geos: linking with ${GEOS_DEP_CLIBS})
  ${CXX} ${CPPFLAGS} -o geos_test geos_test.cpp ${GEOS_DEP_CLIBS} 2> errors.txt
  if test `echo $?` -ne 0 ; then
    geosok=no
    AC_MSG_RESULT(no)
    cat errors.txt
    AC_MSG_NOTICE([Install failure: compilation and/or linkage problems.])
    AC_MSG_ERROR([GEOS_init_r not found in libgeos_c.])
  else
    AC_SUBST([GEOS_LIBS], ["${GEOS_DEP_CLIBS}"])
    AC_MSG_RESULT(yes)
  fi
fi

rm -f geos_test errors.txt geos_test.cpp


#
# liblwgeom
#
AC_SUBST([OBJECTS], ["${OBJECTS} \$(OBJECTS_RCPP)"])

#AC_CHECK_LIB(proj, pj_init_plus,
#         AC_SUBST([PKG_LIBS], ["${PKG_LIBS} -lproj"]), 
#	     AC_MSG_ERROR([libproj not found a standard locations.]))

AC_CHECK_LIB(geos_c, GEOS_init_r,
         AC_SUBST([PKG_LIBS], ["${PKG_LIBS} -lgeos_c"]), 
         AC_SUBST([PKG_LIBS], ["${PKG_LIBS} ${PROJ_LIBS} ${GEOS_LIBS}"]))

AC_SUBST([OBJECTS], ["${OBJECTS} \$(OBJECTS_LIBLWGEOM)"])

AC_SUBST([PKG_CPPFLAGS], ["${PKG_CPPFLAGS} -I./liblwgeom -DHAVE_LIBGEOM_INTERNAL_H"])

#
# concluding substitution
#
AC_MSG_NOTICE([Package CPP flags: ${PKG_CPPFLAGS}])
AC_MSG_NOTICE([Package LIBS: ${PKG_LIBS}])

AC_CONFIG_FILES(src/Makevars
	src/postgis_config.h)
AC_OUTPUT
