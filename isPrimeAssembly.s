.globl isPrimeAssembly
isPrimeAssembly:
    // Preserve registers
    stp     x29, x30, [sp, -32]!    // Save FP and LR, allocate stack frame
    mov     x29, sp                  // Set up frame pointer
    stp     x19, x20, [sp, 16]      // Save callee-saved registers
    
    // Store parameters in callee-saved registers
    mov     x19, x0                  // Input array
    mov     x20, x1                  // Prime array
    mov     x21, x2                  // Composite array
    mov     x22, x3                  // Length
    
    // Initialize counters
    mov     x23, xzr                 // i = 0 (main loop counter)
    mov     x24, xzr                 // j = 0 (prime array index)
    mov     x25, xzr                 // k = 0 (composite array index)
    
main_loop:
    cmp     x23, x22                 // Compare i with length
    b.ge    done                     // If i >= length, exit
    
    // Load current number to test
    lsl     x10, x23, #3            // x10 = i * 8 (for 64-bit values)
    ldr     x0, [x19, x10]          // Load current number into x0
    
    // Test if prime
    bl      isPrime_optimized        // Call optimized prime test
    
    // Load original number again (might have been modified by function call)
    ldr     x10, [x19, x23, lsl #3] // Reload current number
    
    // Branch based on prime test result
    cbz     x0, store_composite
    
store_prime:
    str     x10, [x20, x24, lsl #3] // Store in prime array
    add     x24, x24, #1            // Increment prime array index
    b       continue
    
store_composite:
    str     x10, [x21, x25, lsl #3] // Store in composite array
    add     x25, x25, #1            // Increment composite array index
    
continue:
    add     x23, x23, #1            // Increment main counter
    b       main_loop
    
done:
    // Restore registers and return
    ldp     x19, x20, [sp, 16]      // Restore saved registers
    ldp     x29, x30, [sp], 32      // Restore FP and LR, deallocate stack
    ret

// Optimized isPrime function
isPrime_optimized:
    // Quick check for n <= 1
    cmp     x0, #1
    b.le    return_not_prime
    
    // Check if n == 2
    cmp     x0, #2
    b.eq    return_prime
    
    // Check if even (except 2)
    and     x9, x0, #1              // x9 = n & 1
    cbz     x9, return_not_prime    // If even, not prime
    
    // Initialize for odd numbers only
    mov     x11, #3                 // Start divisor at 3
    
    // Calculate square root of n (rough approximation)
    // We'll use shift right by 1 as an approximation (n/2)
    lsr     x12, x0, #1             // x12 = n/2
    
prime_loop:
    cmp     x11, x12                // Compare divisor with n/2
    b.gt    return_prime            // If divisor > n/2, number is prime
    
    // Check divisibility
    udiv    x13, x0, x11            // x13 = n / divisor
    msub    x13, x13, x11, x0       // x13 = n - (n / divisor) * divisor (remainder)
    cbz     x13, return_not_prime   // If remainder is 0, number is not prime
    
    add     x11, x11, #2            // Increment divisor by 2 (check only odd numbers)
    b       prime_loop
    
return_prime:
    mov     x0, #1
    ret
    
return_not_prime:
    mov     x0, #0
    ret