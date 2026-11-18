# Listing 1.3 - Your own procedure (Extend Listing 1)
.data
title:    .asciiz "SCORE REPORT\n"
endMsg:   .asciiz "END\n"
line:     .asciiz "----------\n"
starLine: .asciiz "**********\n"

.text
.globl main
main:
    jal  stars              # call (1): print **********
    li   $v0, 4
    la   $a0, title
    syscall
    jal  sep                # call (2): print ----------
    li   $v0, 4
    la   $a0, endMsg
    syscall
    jal  stars              # call (3): print **********
    li   $v0, 10
    syscall

# sep: prints a separator line
sep:
    li   $v0, 4
    la   $a0, line
    syscall
    jr   $ra                # return to the caller

# stars: prints a star line
stars:
    li   $v0, 4
    la   $a0, starLine
    syscall
    jr   $ra                # return to the caller