from typing import Dict, Any
import json

def get_user_data() -> Dict[str, Any]:
    return {
        "id": 1,
        "name": "Jan",
        "email": "jan@example.com"
    }

# Test
if __name__ == "__main__":
    user = get_user_data()
    print(user["name"])
    print(json.dumps(user))

