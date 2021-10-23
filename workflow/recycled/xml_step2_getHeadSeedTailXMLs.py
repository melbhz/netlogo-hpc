# -*- coding: utf-8 -*-
"""
Created on Mon Mar 29 21:10:00 2021

@author: haifeng
"""

def MakeHeadless():
    modelFile = open('Experiment_auto.xml', 'r')
    headFile = open('head_.xml', 'w')
    seedFile = open('seed_.xml', 'w')
    tailFile = open('tail_.xml', 'w')
    
    inHead = True
    inSeed = False
    inTail = False
    
    while True:
        # Get next line from file
        line = modelFile.readline()
        if line == '':
            break
        #line = line.rstrip()

        if inSeed and '</enumeratedValueSet>' in line:#seed ends, tail starts
            inHead = False
            inSeed = False
            inTail = True
        
        if inHead:
            headFile.write(line)# + '\n')
        elif inSeed:
            seedFile.write(line)# + '\n')
        elif inTail:
            tailFile.write(line)# + '\n')
            
        if '<enumeratedValueSet variable="rand_seed">' in line:#next line seed starts
            inHead = False
            inSeed = True
            inTail = False
    
    modelFile.close()
    headFile.close()
    seedFile.close()
    tailFile.close()    

MakeHeadless()
