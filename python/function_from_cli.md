```python
def myFunction():
    ...

if __name__ == '__main__':
    globals()[sys.argv[1]]()
```

Usage:
```bash
python myscript.py myfunction
```

With arguments:
```python
def myfunction(mystring):
    print(mystring)

if __name__ == '__main__':
    globals()[sys.argv[1]](sys.argv[2])
```

Usage:
```bash
python myscript.py myfunction "hello"
# Output: hello
```
