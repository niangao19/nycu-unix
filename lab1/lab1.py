#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from pwn import *
import pow
import base64

def solve_math(r) :
    line = r.recvuntil(b"?").decode().split(":")[-1]
    test = line.split(" = ")[0]
    print(f'test : {test}')
    num_ll = eval(test)
    print("ans:  " + str(num_ll))
    ans = num_ll.to_bytes((num_ll.bit_length() + 7) // 8, byteorder='little')
    data = base64.b64encode(ans)
    print(f'send_data : {data}')
    r.sendline(data)


if __name__ == '__main__':

    r = remote('up23.zoolab.org', 10363)
    pow.solve_pow(r)
    count = int(r.recvuntil(b"challenges").decode().split(" ")[-2])
    for i in range(count) :
        solve_math(r)
    r.interactive()
    r.close()