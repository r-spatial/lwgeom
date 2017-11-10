#include <Rcpp.h>

extern "C" {
#include <liblwgeom.h>
}


#define LW_MSG_MAXLEN 256

// #nocov start
static void io_notice(const char *fmt, va_list ap)
{
    char msg[LW_MSG_MAXLEN+1];
    vsnprintf (msg, LW_MSG_MAXLEN, fmt, ap);
    msg[LW_MSG_MAXLEN]='\0';
    Rprintf("%s\n", msg);
}

static void io_debug(int level, const char *fmt, va_list ap)
{
}


static void io_error(const char *fmt, va_list ap)
{
    char msg[LW_MSG_MAXLEN+1];
    vsnprintf (msg, LW_MSG_MAXLEN, fmt, ap);
    msg[LW_MSG_MAXLEN]='\0';
    Rprintf("%s\n", msg);
	Rcpp::stop("lwgeom error");
}
// #nocov end

// [[Rcpp::export]]
Rcpp::List CPL_init_lwgeom(Rcpp::List l) {
	lwgeom_set_debuglogger(io_debug);
	lwgeom_set_handlers(NULL, NULL, NULL, io_error, io_notice);
	return l;
}
