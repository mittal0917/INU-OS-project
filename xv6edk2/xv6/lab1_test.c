#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int pid, child_pid;
  int status, exit_code;

  pid = fork(); // 자식 프로세스를 만듭니다. [cite: 151]
  if(pid < 0) {
    printf(1, "fork failed\n");
    exit2(1);
  }
  
  if(pid == 0){ // 자식 프로세스 영역 [cite: 156]
    printf(1, "This is the child\n");
    exit_code = 37; // 종료 코드 설정 [cite: 159]
    printf(1, "Child exiting with code %d\n", exit_code);
    exit2(exit_code); // 우리가 만든 exit2 호출 [cite: 178]
  } else {      // 부모 프로세스 영역 [cite: 161]
    printf(1, "This is the parent, waiting for child...\n");
    child_pid = wait2(&status); // 우리가 만든 wait2로 자식 대기 [cite: 172]
    printf(1, "Child has finished: PID = %d\n", child_pid); [cite: 173]
    printf(1, "Child exited with code %d\n", status); // 37이 출력되어야 성공! [cite: 175-176]
  }
  exit2(0);
}