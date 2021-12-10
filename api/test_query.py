import unittest
from request_api import RequestAPI 


class Test(unittest.TestCase):

	def setUp(self) -> None:
		self.postcode_one = RequestAPI('CB3 0FA')
		self.postcode_two = RequestAPI('cb30Fa')

	def test_validate(self):
		self.assertEqual(self.postcode_one.is_valid(), True)
		self.assertEqual(self.postcode_two.is_valid(), True)

	def test_nearest(self):
		self.assertIsNone(self.postcode_two.get_nearest())
		self.assertIsNotNone(self.postcode_two.get_nearest(radius=110, limit=20))

	def test_country(self):
		self.assertEqual(self.postcode_one.get_country(), 'England')
		self.assertEqual(self.postcode_two.get_country(), 'England')

	def test_region(self):
		self.assertNotEqual(self.postcode_two.get_region(), 'EastofEngland')
		self.assertEqual(self.postcode_two.get_region(), 'East of England')
	
	
if __name__ == '__main__':
	unittest.main()
