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
AC_ARG_WITH([liblwgeom],
  [AS_HELP_STRING([--with-liblwgeom],
    [use dynamically linking to liblwgeom @<:@default=check@:>@])],
  [],
  [with_liblwgeom=check])
          
AC_SUBST([OBJECTS], ["${OBJECTS} \$(OBJECTS_RCPP)"])

LIBLWGEOM=
  AS_IF([test "x$with_liblwgeom" != xno],
  [AC_CHECK_LIB([lwgeom], lwgeom_make_valid,
     [AC_SUBST([PKG_LIBS], ["${PKG_LIBS} -llwgeom"])
      AC_SUBST([PKG_CPPFLAGS], ["${PKG_CPPFLAGS} -DHAVE_LIBGEOM"])
     ],
     [AC_CHECK_LIB(proj, pj_init_plus,
         AC_SUBST([PKG_LIBS], ["${PKG_LIBS} -lproj"]), 
	     AC_MSG_ERROR([libproj not found a standard locations.]))
      AC_CHECK_LIB(geos_c, GEOS_init_r,
         AC_SUBST([PKG_LIBS], ["${PKG_LIBS} -lgeos_c"]), 
	     AC_MSG_ERROR([libgeos not found a standard locations.]))
      AC_SUBST([OBJECTS], ["${OBJECTS} \$(OBJECTS_LIBLWGEOM)"])
      AC_SUBST([PKG_CPPFLAGS], ["${PKG_CPPFLAGS} -I./liblwgeom"])
	 ],
     -llwgeom)],
   AC_SUBST([PKG_LIBS], ["${PKG_LIBS} -lgeos_c -lproj"])
   AC_SUBST([OBJECTS], ["${OBJECTS} \$(OBJECTS_LIBLWGEOM)"])
  )


#
# concluding substitution
#
AC_MSG_NOTICE([Package CPP flags: ${PKG_CPPFLAGS}])
AC_MSG_NOTICE([Package LIBS: ${PKG_LIBS}])

AC_CONFIG_FILES(src/Makevars)
AC_OUTPUT
