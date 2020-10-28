# -*- coding: utf-8 -*-
"""
Created on Sat Sep 15 11:55:42 2018

@author: kingquote
"""
import random
secret = random.randint(1, 99)  # Picks secret number
guess = 0
tries = 0
print ("AHOY! I'm the Dread Pirate Roberts, and I have a secret!")
print ("It is a number from 1 to 99. I'll give you 6 tries.")

# Allows up to 6 guesses
while guess != secret and tries < 6:
    guess = int(input("What's yer guess? "))  # Gets player’s guess
    if guess < secret:
        print ("Too low, ye scurvy dog!")
    elif guess > secret:
        print ("Too high, landlubber!")
    tries = tries + 1                          # Uses up one try

# Prints a message at the end of the game
if guess == secret:
    print ("Avast! Ye got it! Found my secret, ye did!")
else:
    print ("No more guesses! Better luck next time, matey!")
    print ("The secret number was", secret)