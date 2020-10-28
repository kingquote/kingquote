def fib(n):
    if n<2:
        return 1,1
    tup = fib(n-1)
    return (sum(tup),tup[0])

print(fib(50)[0])