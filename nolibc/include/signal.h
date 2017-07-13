#ifndef _SIGNAL_H
#define _SIGNAL_H

#include <sys/types.h>

typedef int sigjmp_buf;
typedef int sigset_t;
struct sigaction {
    void (*sa_handler)(int);
    sigset_t sa_mask;
    int sa_flags;
};
#define SIG_DFL NULL
#define SIG_IGN NULL
int sigaction(int, const struct sigaction *, struct sigaction *);
int sigsetjmp(sigjmp_buf, int);
int sigaddset(sigset_t *set, int);
int sigdelset(sigset_t *set, int);
int sigemptyset(sigset_t *set);
#define SIG_BLOCK 0
#define SIG_SETMASK 0
#define SIGCONT 0
int sigprocmask(int, const sigset_t *, sigset_t *);
int kill(pid_t pid, int sig);
/*
 * The following definitions are not required by the OCaml runtime, but are
 * needed to build the freestanding version of GMP used by Mirage.
 */
#define SIGFPE 1
int raise(int);

#endif
