#!/usr/bin/env python3
# -*- coding: utf-8 -*-

class got :
   def __init__(self, codename, got, symbols):
      self.codename = codename
      self.got = got
      self.symbols = symbols

def getKey(obj):
    num = obj.codename.split('_', 1)
    return int(num[-1])

from pwn import *
elf = ELF('./chals')
print("main =", hex(elf.symbols['main']))
print("{:<12s} {:<8s} {:<8s}".format("Func", "GOT Offset", "Symbol Offset"))
f = open("test.txt", "w+")
got_table = []
for g in elf.got:
   if "code_" in g:
      # print("{:<12s} {:<8x} {:<8x}".format(g, elf.got[g], elf.symbols[g]))
      got_table.append(got(g, elf.got[g], elf.symbols[g] ) )

f.write( "code_name = {" )
for i in range(len(got_table) ) :
      code = got_table[i]
      f.write( "{:s}  ,".format(code.codename.split('_', 1)[-1]))

f.write( "};\ngot_table = {" )
for i in range(len(got_table) ) :
      code = got_table[i]
      f.write( "\"{:x}\"  ,".format(code.got))
      # print("{:<s} {:<8x} {:<8x}".format(code.codename, code.got, code.symbols)) 

f.write( "};\n symbols = {" )
for i in range(len(got_table) ) :
      code = got_table[i]
      f.write( "\"{:x}\"  ,".format( code.symbols ))  
f.write( "};\n")      