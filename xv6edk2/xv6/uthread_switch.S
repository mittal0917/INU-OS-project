.text
.globl thread_switch
thread_switch:
    pushal
    // 현재 스레드의 상태(스택 포인터) 저장
    movl current_thread, %eax
    movl %esp, (%eax)
    
    // 다음 스레드의 상태(스택 포인터) 복원
    movl next_thread, %eax
    movl (%eax), %esp
    
    // 누락된 부분: current_thread를 next_thread로 갱신
    movl %eax, current_thread  
    popal
    ret