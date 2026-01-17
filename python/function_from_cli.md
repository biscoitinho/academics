def myFunction():
        ...

if __name__ =  '__main__':
        globals()[sys.argv[1]]()

# => python myscript.py myfunction

def myfunction(mystring):
        print(mystring)

if __name__ =  '__main__':
        globals()[sys.argv[1]](sys.argv[2])

# => python myscript.py myfunction "hello" => "hello"
