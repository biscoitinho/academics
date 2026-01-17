Polymorphism is based on the greek words Poly (many) and morphism (forms).
Ability to create a structure that can take or use many forms of objects.
Overwriting inherited function

Polymorphism with abstract class (most commonly used)

```python
class Document:
    def __init__(self, name):
        self.name = name

    def show(self):
        raise NotImplementedError("Subclass must implement abstract method")

class Pdf(Document):
    def show(self):
        return 'Show pdf contents!'

class Word(Document):
    def show(self):
        return 'Show word contents!'

documents = [Pdf('Document1'),
Pdf('Document2'),
Word('Document3')]

for document in documents:
    print document.name + ': ' + document.show()
```
