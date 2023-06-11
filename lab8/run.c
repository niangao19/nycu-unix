#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <sys/user.h>
#include <stdbool.h>

pid_t child = 0;
struct user_regs_struct regs;
int wait_status;
unsigned long address = 0;
void errquit(const char *msg) {
	perror(msg);
	exit(-1);
}

bool generateBinary(int n, char* result, int index ) {
    bool have_ans = false;

    if (index == n) {
        // 恢復reg的值
        // 把rip設在main起點
        // 修改magic number
        struct user_regs_struct this_regs;

        int cont = 0;

        if ( ptrace(PTRACE_SETREGS, child, NULL, &regs) < 0)errquit("PTRACE_SETREGS");
        // result[index-1] = '1';
        for (int i = 0; i < n; i++) {
            if( ptrace(PTRACE_POKEDATA, child, (void*)(address + i*sizeof(char)), result[i]  ) < 0 )
                errquit("ptrace@POKEDATA");

        } // for


        while ( WIFSTOPPED(wait_status) ) {
            cont++;
            // printf( "cont\n");
            if(ptrace(PTRACE_CONT, child, 0, 0) < 0) errquit("ptrace@parent");
            if(waitpid(child, &wait_status, 0) < 0) errquit("waitpid");
            if(  cont == 2 ) {
                if ( ptrace(PTRACE_GETREGS, child, NULL, &this_regs) < 0)errquit("PTRACE_GETREGS");
                if ( this_regs.rax == 0  )
                   have_ans = true;
            } // if
            if(  cont == 3 ) {
                return have_ans;
            } // if

        } // while

        // printf("Magic evaluated: %s\n", magic);
        // 取得oracle_get_flag的回傳值如果是 1 retrun true else false
    }

    if (  !have_ans ) {
        result[index] = '0';
        have_ans = generateBinary(n, result, index+1);
    }

    if (  !have_ans ) {
        result[index] = '1';
        have_ans = generateBinary(n, result, index+1);
    }

    return have_ans;
}




int main(int argc, char *argv[]) {

    char result[11];
	if(argc < 2) {
		fprintf(stderr, "usage: %s program [args ...]\n", argv[0]);
		return -1;
	}

    if((child = fork()) < 0) errquit("fork");
    if(child == 0) {
        if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) errquit("ptrace@child");
        execvp(argv[1], argv+1);
        errquit("execvp");
    } // if
    else {
        if(waitpid(child, &wait_status, 0) < 0)
            errquit("waitpid");

        ptrace(PTRACE_ATTACH, child, NULL, NULL);
        if (ptrace(PTRACE_SETOPTIONS, child, 0, PTRACE_O_EXITKILL) < 0)errquit("PTRACE_SETOPTIONS");
        int count = 0;
        while (WIFSTOPPED(wait_status)) {
            count++;
            ptrace(PTRACE_CONT, child, 0, 0);
            if(waitpid(child, &wait_status, 0) < 0) errquit("waitpid");
                    
            // 存取reg值
            // printf( "cont1\n");
            if( count == 2 ) {
                if ( ptrace(PTRACE_GETREGS, child, NULL, &regs) < 0)errquit("PTRACE_GETREGS");
                address = regs.rax;
            }  // if
            else if( count == 3 ) {
                if ( ptrace(PTRACE_GETREGS, child, NULL, &regs) < 0)errquit("PTRACE_GETREGS");
                break;
            } // else if

        } // while
        
        generateBinary(9, result, 0 );
 
        while (WIFSTOPPED(wait_status)) {
            // printf( "cont2\n");
            ptrace(PTRACE_CONT, child, 0, 0);
            if(waitpid(child, &wait_status, 0) < 0) errquit("waitpid");
        } // while

        // 跑到直到return0
    } // else
    
	return 0;
}

