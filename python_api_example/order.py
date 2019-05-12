import requests


base_url = 'http://localhost:3000'
user = 'j'
user_token = 'uiUTrjuD3ZSft6s8JD9S4g=='

headers = {'Authorization': f'Token token={user_token}'}
product = 1

data = {"order": {"order_items_attributes": [{"count": 1, "product_id": product}]}}

r = requests.post(f'{base_url}/users/{user}/orders.json', headers=headers, json=data)
print(r.text)
