from pydantic import BaseModel, EmailStr

class User(BaseModel):
    id: int
    name: str
    email: EmailStr

def get_user_data() -> User:
    return User(id=1, name="Jan", email="jan@example.com")

# Test
if __name__ == "__main__":
    user = get_user_data()
    print(user.model_dump())       # {'id': 1, 'name': 'Jan', 'email': 'jan@example.com'}
    print(user.email)              # jan@example.com

