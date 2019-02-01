# This script is used for updating the descriptions of the problems.

# After running this script:
# 1. Links to binaries in the description will no longer be local 
#    (ie. 192.168.137.3), but with the remote server + associated port if
#    using more than one box (ie. example.com:8000).
# 2. The description of each problem will no longer contain the instance
#    number. (It is preferred the competitor does not know which instance
#    of a problem they are working with.)
# 3. The problem directory on the description is corrected to '~/problems'
#    rather than '/problems'.


from pymongo import MongoClient

client = MongoClient()
# print(client.list_database_names())		# Lists the databases
db = client.picoCTF
# print(db.list_collection_names())			# Lists the tables in the db
problems = db.problems

sanitized_names = ['bagel-shop', 'can-i-have-flag', 'js-safe', 'postable', 'we-rate-birds', 'word-lock']
# sanitized_names = ['chair-snote', 'ceo-snote', 'recoverpw', 'cfo-snote', 'cto-snote']	# Sanitized problem names
# names = ['chair.snote', 'ceo.snote', 'recoverpw', 'cfo.snote', 'cto.snote']				# Original problem names 
# port = [2123, 2123, 2122, 2122, 2122]													# Which machine each problem is located on

local_server = '//192.168.2.3'						        # The original local server address
remote_server ='http://problems.getpwning.com:2123'		# The remote server address to replace with

# Go through each challenge problem (i) and pull its information from the db.
for i in range(len(sanitized_names)):				
	n_instance = len(problems.find_one({'sanitized_name' : sanitized_names[i]})['instances'])
	print(sanitized_names[i],  n_instance)			# Prints the challenge name & num of instances

	# Go through each instance of the problem (j) and get the description.
	for j in range(n_instance):
		# Replace the local server IP address with the remote server.
		description = problems.find_one({'sanitized_name' : sanitized_names[i]})['instances'][j]['description']
		new_description = description.replace(local_server, remote_server)
		#instance_number = problems.find_one({'sanitized_name' : sanitized_names[i]})['instances'][j]['instance_number']
		#new_description = new_description.replace('<code>/problems/', '<code>~/problems/')
		#new_description = new_description.replace('%s_%d' % (sanitized_names[i], instance_number), names[i])
		#print(new_description)						# Prints the updated description

		# Update the description in the database.
		problems.update({"sanitized_name" : "%s" % sanitized_names[i]}, {"$set": {"instances.%d.description" % j : "%s" % new_description}})
