# Extension - Two results from one call: min_max(addr, n)
.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
minA:   .asciiz "Class A min: "
maxA:   .asciiz "Class A max: "
minB:   .asciiz "Class B min: "
maxB:   .asciiz "Class B max: "
nl:     .asciiz "\n"

.text
.globl main
main:
    # --- Class A ---
    la   $a0, classA            # argument 1: address of classA[0]
    addi $a1, $zero, 10         # argument 2: number of scores
    jal  min_max                # $v0 = min, $v1 = max
    add  $s0, $v0, $zero        # save min in $s0
    add  $s1, $v1, $zero        # save max in $s1

    la   $a0, minA
    add  $a1, $s0, $zero
    jal  show                   # prints Class A min: 39

    la   $a0, maxA
    add  $a1, $s1, $zero
    jal  show                   # prints Class A max: 94

    # --- Class B ---
    la   $a0, classB            # argument 1: address of classB[0]
    addi $a1, $zero, 8          # argument 2: number of scores
    jal  min_max                # $v0 = min, $v1 = max
    add  $s0, $v0, $zero        # save min in $s0
    add  $s1, $v1, $zero        # save max in $s1

    la   $a0, minB
    add  $a1, $s0, $zero
    jal  show                   # prints Class B min: 38

    la   $a0, maxB
    add  $a1, $s1, $zero
    jal  show                   # prints Class B max: 92

    li   $v0, 10
    syscall

# min_max(addr = $a0, n = $a1): returns min in $v0 and max in $v1
min_max:
    lw   $v0, 0($a0)            # min = array[0]
    lw   $v1, 0($a0)            # max = array[0]
    addi $t0, $zero, 1          # i = 1
mm_loop:
    slt  $t1, $t0, $a1          # $t1 = 1 if i < n
    beq  $t1, $zero, mm_end     # if i >= n, exit loop
    sll  $t2, $t0, 2            # $t2 = 4 * i
    add  $t2, $t2, $a0          # $t2 = address of array[i]
    lw   $t3, 0($t2)            # $t3 = array[i]

    slt  $t1, $t3, $v0          # $t1 = 1 if array[i] < min
    beq  $t1, $zero, check_max
    add  $v0, $t3, $zero        # min = array[i]

check_max:
    slt  $t1, $v1, $t3          # $t1 = 1 if max < array[i]
    beq  $t1, $zero, mm_next
    add  $v1, $t3, $zero        # max = array[i]

mm_next:
    addi $t0, $t0, 1            # i = i + 1
    j    mm_loop
mm_end:
    jr   $ra

# show(msg = $a0, value = $a1): prints msg, value and a new line
show:
    li   $v0, 4                 # $a0 already holds the address of msg
    syscall
    li   $v0, 1
    add  $a0, $a1, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall
    jr   $ra