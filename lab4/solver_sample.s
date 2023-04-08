
solver_sample:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fd9]        # 3fe8 <__gmon_start__@Base>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 92 2f 00 00    	push   QWORD PTR [rip+0x2f92]        # 3fb8 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	f2 ff 25 93 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f93]        # 3fc0 <_GLOBAL_OFFSET_TABLE_+0x10>
    102d:	0f 1f 00             	nop    DWORD PTR [rax]
    1030:	f3 0f 1e fa          	endbr64 
    1034:	68 00 00 00 00       	push   0x0
    1039:	f2 e9 e1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    103f:	90                   	nop

Disassembly of section .plt.got:

0000000000001040 <printf@plt>:
    1040:	f3 0f 1e fa          	endbr64 
    1044:	f2 ff 25 95 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f95]        # 3fe0 <printf@GLIBC_2.2.5>
    104b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001050 <__cxa_finalize@plt>:
    1050:	f3 0f 1e fa          	endbr64 
    1054:	f2 ff 25 9d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f9d]        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    105b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .plt.sec:

0000000000001060 <__stack_chk_fail@plt>:
    1060:	f3 0f 1e fa          	endbr64 
    1064:	f2 ff 25 5d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f5d]        # 3fc8 <__stack_chk_fail@GLIBC_2.4>
    106b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .text:

0000000000001070 <_start>:
    1070:	f3 0f 1e fa          	endbr64 
    1074:	31 ed                	xor    ebp,ebp
    1076:	49 89 d1             	mov    r9,rdx
    1079:	5e                   	pop    rsi
    107a:	48 89 e2             	mov    rdx,rsp
    107d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    1081:	50                   	push   rax
    1082:	54                   	push   rsp
    1083:	45 31 c0             	xor    r8d,r8d
    1086:	31 c9                	xor    ecx,ecx
    1088:	48 8d 3d 38 01 00 00 	lea    rdi,[rip+0x138]        # 11c7 <main>
    108f:	ff 15 3b 2f 00 00    	call   QWORD PTR [rip+0x2f3b]        # 3fd0 <__libc_start_main@GLIBC_2.34>
    1095:	f4                   	hlt    
    1096:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    109d:	00 00 00 

00000000000010a0 <deregister_tm_clones>:
    10a0:	48 8d 3d 69 2f 00 00 	lea    rdi,[rip+0x2f69]        # 4010 <__TMC_END__>
    10a7:	48 8d 05 62 2f 00 00 	lea    rax,[rip+0x2f62]        # 4010 <__TMC_END__>
    10ae:	48 39 f8             	cmp    rax,rdi
    10b1:	74 15                	je     10c8 <deregister_tm_clones+0x28>
    10b3:	48 8b 05 1e 2f 00 00 	mov    rax,QWORD PTR [rip+0x2f1e]        # 3fd8 <_ITM_deregisterTMCloneTable@Base>
    10ba:	48 85 c0             	test   rax,rax
    10bd:	74 09                	je     10c8 <deregister_tm_clones+0x28>
    10bf:	ff e0                	jmp    rax
    10c1:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    10c8:	c3                   	ret    
    10c9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

00000000000010d0 <register_tm_clones>:
    10d0:	48 8d 3d 39 2f 00 00 	lea    rdi,[rip+0x2f39]        # 4010 <__TMC_END__>
    10d7:	48 8d 35 32 2f 00 00 	lea    rsi,[rip+0x2f32]        # 4010 <__TMC_END__>
    10de:	48 29 fe             	sub    rsi,rdi
    10e1:	48 89 f0             	mov    rax,rsi
    10e4:	48 c1 ee 3f          	shr    rsi,0x3f
    10e8:	48 c1 f8 03          	sar    rax,0x3
    10ec:	48 01 c6             	add    rsi,rax
    10ef:	48 d1 fe             	sar    rsi,1
    10f2:	74 14                	je     1108 <register_tm_clones+0x38>
    10f4:	48 8b 05 f5 2e 00 00 	mov    rax,QWORD PTR [rip+0x2ef5]        # 3ff0 <_ITM_registerTMCloneTable@Base>
    10fb:	48 85 c0             	test   rax,rax
    10fe:	74 08                	je     1108 <register_tm_clones+0x38>
    1100:	ff e0                	jmp    rax
    1102:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1108:	c3                   	ret    
    1109:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001110 <__do_global_dtors_aux>:
    1110:	f3 0f 1e fa          	endbr64 
    1114:	80 3d f5 2e 00 00 00 	cmp    BYTE PTR [rip+0x2ef5],0x0        # 4010 <__TMC_END__>
    111b:	75 2b                	jne    1148 <__do_global_dtors_aux+0x38>
    111d:	55                   	push   rbp
    111e:	48 83 3d d2 2e 00 00 	cmp    QWORD PTR [rip+0x2ed2],0x0        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1125:	00 
    1126:	48 89 e5             	mov    rbp,rsp
    1129:	74 0c                	je     1137 <__do_global_dtors_aux+0x27>
    112b:	48 8b 3d d6 2e 00 00 	mov    rdi,QWORD PTR [rip+0x2ed6]        # 4008 <__dso_handle>
    1132:	e8 19 ff ff ff       	call   1050 <__cxa_finalize@plt>
    1137:	e8 64 ff ff ff       	call   10a0 <deregister_tm_clones>
    113c:	c6 05 cd 2e 00 00 01 	mov    BYTE PTR [rip+0x2ecd],0x1        # 4010 <__TMC_END__>
    1143:	5d                   	pop    rbp
    1144:	c3                   	ret    
    1145:	0f 1f 00             	nop    DWORD PTR [rax]
    1148:	c3                   	ret    
    1149:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001150 <frame_dummy>:
    1150:	f3 0f 1e fa          	endbr64 
    1154:	e9 77 ff ff ff       	jmp    10d0 <register_tm_clones>

0000000000001159 <solver>:
    1159:	f3 0f 1e fa          	endbr64 
    115d:	55                   	push   rbp
    115e:	48 89 e5             	mov    rbp,rsp
    1161:	48 83 ec 30          	sub    rsp,0x30
    1165:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
    1169:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1170:	00 00 
    1172:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    1176:	31 c0                	xor    eax,eax
    1178:	48 b8 68 65 6c 6c 6f 	movabs rax,0x77202c6f6c6c6568
    117f:	2c 20 77 
    1182:	48 ba 6f 72 6c 64 21 	movabs rdx,0x21646c726f
    1189:	00 00 00 
    118c:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
    1190:	48 89 55 e8          	mov    QWORD PTR [rbp-0x18],rdx
    1194:	48 8d 45 e0          	lea    rax,[rbp-0x20]
    1198:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
    119c:	48 89 c6             	mov    rsi,rax
    119f:	48 8d 05 5e 0e 00 00 	lea    rax,[rip+0xe5e]        # 2004 <_IO_stdin_used+0x4>
    11a6:	48 89 c7             	mov    rdi,rax
    11a9:	b8 00 00 00 00       	mov    eax,0x0
    11ae:	ff d2                	call   rdx
    11b0:	90                   	nop
    11b1:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    11b5:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    11bc:	00 00 
    11be:	74 05                	je     11c5 <solver+0x6c>
    11c0:	e8 9b fe ff ff       	call   1060 <__stack_chk_fail@plt>
    11c5:	c9                   	leave  
    11c6:	c3                   	ret    

00000000000011c7 <main>:
    11c7:	f3 0f 1e fa          	endbr64 
    11cb:	55                   	push   rbp
    11cc:	48 89 e5             	mov    rbp,rsp
    11cf:	48 83 ec 20          	sub    rsp,0x20
    11d3:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    11da:	00 00 
    11dc:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    11e0:	31 c0                	xor    eax,eax
    11e2:	48 b8 2a 2a 20 6d 61 	movabs rax,0x206e69616d202a2a
    11e9:	69 6e 20 
    11ec:	48 ba 3d 20 25 70 0a 	movabs rdx,0xa7025203d
    11f3:	00 00 00 
    11f6:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
    11fa:	48 89 55 e8          	mov    QWORD PTR [rbp-0x18],rdx
    11fe:	48 8d 45 e0          	lea    rax,[rbp-0x20]
    1202:	48 8d 15 be ff ff ff 	lea    rdx,[rip+0xffffffffffffffbe]        # 11c7 <main>
    1209:	48 89 d6             	mov    rsi,rdx
    120c:	48 89 c7             	mov    rdi,rax
    120f:	b8 00 00 00 00       	mov    eax,0x0
    1214:	e8 27 fe ff ff       	call   1040 <printf@plt>
    1219:	48 8b 05 c0 2d 00 00 	mov    rax,QWORD PTR [rip+0x2dc0]        # 3fe0 <printf@GLIBC_2.2.5>
    1220:	48 89 c7             	mov    rdi,rax
    1223:	e8 31 ff ff ff       	call   1159 <solver>
    1228:	b8 00 00 00 00       	mov    eax,0x0
    122d:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
    1231:	64 48 2b 14 25 28 00 	sub    rdx,QWORD PTR fs:0x28
    1238:	00 00 
    123a:	74 05                	je     1241 <main+0x7a>
    123c:	e8 1f fe ff ff       	call   1060 <__stack_chk_fail@plt>
    1241:	c9                   	leave  
    1242:	c3                   	ret    

Disassembly of section .fini:

0000000000001244 <_fini>:
    1244:	f3 0f 1e fa          	endbr64 
    1248:	48 83 ec 08          	sub    rsp,0x8
    124c:	48 83 c4 08          	add    rsp,0x8
    1250:	c3                   	ret    
