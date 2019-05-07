import requests


base_url = 'http://localhost:3000'
user = 'j'
user_token = 'uiUTrjuD3ZSft6s8JD9S4g=='

headers = {'Authorization': f'Token token={user_token}'}
dagschotel_id = 1

r = requests.put(f'{base_url}/users/{user}.json', headers=headers, json={'dagschotel_id': 20})
print(r.text)

r = requests.get(f'{base_url}/users/{user}.json', headers=headers)
print(r.text)
