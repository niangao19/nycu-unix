quick_sort:
    endbr64 
    push   rbp
    mov    rbp, rsp
    sub    rsp, 0x30
    mov    QWORD PTR [rbp-0x28], rdi
    mov    DWORD PTR [rbp-0x2c], esi
    mov    DWORD PTR [rbp-0x18], 0x0
    mov    eax, DWORD PTR [rbp-0x2c]
    sub    eax, 0x1
    mov    DWORD PTR [rbp-0x14], eax
    mov    eax, DWORD PTR [rbp-0x18]
    
    cmp    eax, DWORD PTR [rbp-0x14]
    jge    quick_sort+0x185
    mov    eax, DWORD PTR [rbp-0x14]
    cdqe   
    lea    rdx, [rax*8+0x0]

    mov    rax, QWORD PTR [rbp-0x28]
    add    rax, rdx
    mov    rax, QWORD PTR [rax]
    mov    QWORD PTR [rbp-0x10], rax
    mov    eax, DWORD PTR [rbp-0x18]
    sub    eax, 0x1
    mov    DWORD PTR [rbp-0x20], eax
    mov    eax, DWORD PTR [rbp-0x18]
    mov    DWORD PTR [rbp-0x1c], eax
    jmp    quick_sort+0xe8
    mov    eax, DWORD PTR [rbp-0x1c]
    cdqe   
    lea    rdx, [rax*8+0x0]

    mov    rax, QWORD PTR [rbp-0x28]
    add    rax, rdx
    mov    rax, QWORD PTR [rax]
    cmp    QWORD PTR [rbp-0x10], rax
    jle    quick_sort+0xe4
    add    DWORD PTR [rbp-0x20], 0x1
    mov    eax, DWORD PTR [rbp-0x20]
    cdqe   
    lea    rdx, [rax*8+0x0]

    mov    rax, QWORD PTR [rbp-0x28]
    add    rax, rdx
    mov    rax, QWORD PTR [rax]
    mov    QWORD PTR [rbp-0x8], rax
    mov    eax, DWORD PTR [rbp-0x1c]
    cdqe   
    lea    rdx, [rax*8+0x0]

    mov    rax, QWORD PTR [rbp-0x28]
    add    rax, rdx
    mov    edx, DWORD PTR [rbp-0x20]
    movsxd rdx, edx
    lea    rcx, [rdx*8+0x0]

    mov    rdx, QWORD PTR [rbp-0x28]
    add    rdx, rcx
    mov    rax, QWORD PTR [rax]
    mov    QWORD PTR [rdx], rax
    mov    eax, DWORD PTR [rbp-0x1c]
    cdqe   
    lea    rdx, [rax*8+0x0]

    mov    rax, QWORD PTR [rbp-0x28]
    add    rdx, rax
    mov    rax, QWORD PTR [rbp-0x8]
    mov    QWORD PTR [rdx], rax
    add    DWORD PTR [rbp-0x1c], 0x1
    mov    eax, DWORD PTR [rbp-0x14]
    cmp    eax, DWORD PTR [rbp-0x1c]
    jg     quick_sort+0x5e
    mov    eax, DWORD PTR [rbp-0x20]
    cdqe   
    add    rax, 0x1
    lea    rdx, [rax*8+0x0]

    mov    rax, QWORD PTR [rbp-0x28]
    add    rax, rdx
    mov    edx, DWORD PTR [rbp-0x14]
    movsxd rdx, edx
    lea    rcx, [rdx*8+0x0]

    mov    rdx, QWORD PTR [rbp-0x28]
    add    rdx, rcx
    mov    rax, QWORD PTR [rax]
    mov    QWORD PTR [rdx], rax
    mov    eax, DWORD PTR [rbp-0x20]
    cdqe   
    add    rax, 0x1
    lea    rdx, [rax*8+0x0]

    mov    rax, QWORD PTR [rbp-0x28]
    add    rdx, rax
    mov    rax, QWORD PTR [rbp-0x10]
    mov    QWORD PTR [rdx], rax
    mov    eax, DWORD PTR [rbp-0x20]
    lea    edx, [rax+0x1]
    mov    rax, QWORD PTR [rbp-0x28]
    mov    esi, edx
    mov    rdi, rax
    call   quick_sort
    mov    eax, DWORD PTR [rbp-0x14]
    sub    eax, DWORD PTR [rbp-0x20]
    lea    edx, [rax-0x1]
    mov    eax, DWORD PTR [rbp-0x20]
    cdqe   
    add    rax, 0x2
    lea    rcx, [rax*8+0x0]

    mov    rax, QWORD PTR [rbp-0x28]
    add    rax, rcx
    mov    esi, edx
    mov    rdi, rax
    call   quick_sort
    nop
    leave  
    ret