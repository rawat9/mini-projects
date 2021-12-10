import requests


class RequestAPI:

	def __init__(self, postcode):
		self.base_url = f"https://api.postcodes.io/postcodes/{postcode}"
	

	def is_valid(self) -> bool: 
		"""
		Check if the given postcode is valid 

		Returns
		-------
		bool : True/False

		Examples
		--------
		>>> qs = RequestAPI('CB3 0FA')
		>>> qs.is_valid()
		True
		>>> qs = RequestAPI('cb30Fa')
		>>> qs.is_valid()
		True
		"""
		url = self.base_url + "/validate"
		response = requests.get(url)
		data = response.json()
		return data['result']


	def get_country(self) -> str:
		"""
		Return the country with associated postcode

		Returns
		-------
		str : country name. Invalid postcode
			  if the given postcode is invalid

		Examples
		--------
		>>> qs = RequestAPI('CB3 0FA')
		>>> qs.get_country()
		'England'
		"""
		response = requests.get(self.base_url)
		data = response.json()
		return data['result']['country'] if self.is_valid() else 'Invalid postcode'


	def get_region(self) -> str:
		"""
		Return the region with associated postcode

		Returns
		-------
		str : region name. Invalid postcode
			  if the given postcode is invalid
			  
		Examples
		--------
		>>> qs = RequestAPI('CB3 0FA')
		>>> qs.get_region()
		'East of England'
		"""
		response = requests.get(self.base_url)
		data = response.json()
		return data['result']['region'] if self.is_valid() else 'Invalid postcode'


	def get_nearest(self, radius=100, limit=10) -> list[list]:
		"""
		Check if the given postcode is valid 

		Parameters
		----------
		int : radius, limit
				
			radius:	Limits number of postcodes matches to return. 
					Defaults to 100m. Needs to be less than 2,000m.

			limit:  Limits number of postcodes matches to return. 
					Defaults to 10. Needs to be less than 100.

		Returns
		-------
		list[list] : nearest
				  List of postcodes with the 
				  corresponding country and region
				  based on a given valid postcode

		Examples
		--------
		>>> qs = RequestAPI('CB3 0FA')
		>>> qs.get_nearest() is None
		True
		>>> qs.get_nearest(105)
		[['CB3 0FZ', 'England', 'East of England']]
		"""
		assert radius < 2000, 'Needs to be less than 2000'
		assert limit < 100, 'Needs to be less than 100'

		url = self.base_url + "/nearest"
		response = requests.get(url, params={'radius': radius, 'limit': limit})
		data = response.json()

		nearest = []

		if self.is_valid():
			for d in data['result']:
				nearest.append([d['postcode'], d['country'], d['region']])

		return None if len(nearest[1:]) == 0 else nearest[1:]


	def get_suggestions(self, limit=10) -> list:
		"""
		Suggestions that matches to incomplete postcode
				
		Parameters
		----------
		limit : int

			limit:  Limits number of postcodes matches to return. 
					Defaults to 10. Needs to be less than 100.

		Returns
		-------
		list :  List of suggestions that matches 
				the given partial postcode

		Examples
		--------
		>>> qs = RequestAPI('CB1 0B')
		>>> qs.get_suggestions()
		['CB1 0BB', 'CB1 0BE', 'CB1 0BG', 'CB1 0BX']
		"""
		assert limit < 100, 'Needs to be less than 100'

		url = self.base_url + "/autocomplete"
		response = requests.get(url, params={'limit': limit})
		data = response.json()
		return data['result']


if __name__ == '__main__':
	import doctest
	doctest.testmod()
