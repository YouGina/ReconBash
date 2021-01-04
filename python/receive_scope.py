import requests 
import json 
import sys 
import os 
from shutil import copyfile


if not sys.argv[1]:
    print("First argument should be your HackerOne token!")
    sys.exit()
else:
    token = sys.argv[1]

if "TARGET_PATH" in os.environ:
    target = os.environ["TARGETS_PATH"]+"/"
else:
    print("Set TARGET_PATH before running!")
    sys.exit()

program_blacklist = [] # List program names here, for example programs you want to exclude or programs who don't allow automation

class handlers(dict):
	def __init__(self):
		self = dict()
	
	def add(self, key, value):
		self[key] = value

def baseProcess(handle, scope, type, list):
	if len(list) > 0:
		dir = target+handle
		if not os.path.exists(dir):
			os.makedirs(dir)
		print("\r\n\r\n___________________________")
		print(handle + "(%s)" % type)
		print(list)
		print("\r\n\r\n___________________________")

def processURL(handle, scope, type, list):
	baseProcess(handle, scope, type, list)
	if len(list) > 0:
		dir = target+handle
		if(scope == "in_scope"):
			domains_file = "domains"
			domains_others_file = "domains_final"
		else:
			domains_file = "out_scope_wildcard"
			domains_others_file = "out_scope_others"
		for item in list:
			item = item.replace("/*", "").replace("https://", "").replace("http://", "").replace("/", "")
			if "*." in item:
				with open(dir+"/"+domains_file, "a+") as f:
					domain = item.split("*.")[-1]
					if("." in domain):
						f.write(domain+"\n")
			else:
				with open(dir+"/"+domains_others_file, "a+") as f:
					f.write(item+"\n")
		if(scope == "in_scope"):
			if(os.path.exists(dir+"/domains")):
				copyfile(dir+"/domains", dir+"/scope_wildcard")
			if(os.path.exists(dir+"/domains_final")):
				copyfile(dir+"/domains_final", dir+"/scope_others")

def writeScopeOthers(handle, scope, type, list):
	if len(list) > 0 and scope == "in_scope":
		dir = target+handle
		with open(dir+"/in_scope_"+type, "a+") as f:
			for item in list:
				f.write(item+"\n")
			

def processCIDR(handle, scope, type, list):
	baseProcess(handle, scope, type, list)
	writeScopeOthers(handle, scope, type, list)
	
def processGOOGLE_PLAY_APP_ID(handle, scope, type, list):
	baseProcess(handle, scope, type, list)
	writeScopeOthers(handle, scope, type, list)
	
def processOTHER_APK(handle, scope, type, list):
	baseProcess(handle, scope, type, list)
	writeScopeOthers(handle, scope, type, list)
	
def processSOURCE_CODE(handle, scope, type, list):
	baseProcess(handle, scope, type, list)
	writeScopeOthers(handle, scope, type, list)
	
def processOTHER(handle, scope, type, list):
	baseProcess(handle, scope, type, list)
	writeScopeOthers(handle, scope, type, list)
	
function_list = { 
	"processURL": processURL,
	"processCIDR": processCIDR,
	"processGOOGLE_PLAY_APP_ID": processGOOGLE_PLAY_APP_ID,
	"processOTHER_APK": processOTHER_APK,
	"processSOURCE_CODE": processSOURCE_CODE,
	"processOTHER": processOTHER
}


burp0_url = "https://hackerone.com:443/graphql?"
burp0_headers = {
	"content-type": "application/json",
	"x-auth-token": token
}
burp0_json={"query": "query My_programs($state_0:[InvitationStateEnum]!,$first_1:Int!,$secure_order_by_2:FiltersTeamFilterOrder!,$where_3:FiltersTeamFilterInput!,$size_4:ProfilePictureSizes!) {query {id,...F4}} fragment F0 on User {_soft_launch_invitations2KlypH:soft_launch_invitations(state:$state_0) {total_count},id} fragment F1 on Team {currency,average_bounty_lower_amount,average_bounty_upper_amount,id} fragment F2 on Team {currency,base_bounty,id} fragment F3 on Team {resolved_report_count,id} fragment F4 on Query {me {id,...F0},_teamsK4Kj0:teams(first:$first_1,secure_order_by:$secure_order_by_2,where:$where_3) {pageInfo {hasNextPage,hasPreviousPage},edges {cursor,node {id,handle,name,currency,_profile_picture1Fh783:profile_picture(size:$size_4),submission_state,triage_active,state,started_accepting_at,number_of_reports_for_user,number_of_valid_reports_for_user,bounty_earned_for_user,last_invitation_accepted_at_for_user,...F1,...F2,...F3}}},id}", "variables": {"first_1": 500, "secure_order_by_2": {"started_accepting_at": {"_direction": "DESC"}}, "size_4": "medium", "state_0": "open", "where_3": {"_and": [{"_or": [{"submission_state": {"_eq": "open"}}, {"submission_state": {"_is_null": True}}]}, {"_or": [{"_and": [{"whitelisted_hackers": {"is_me": True}}, {"state": {"_eq": "soft_launched"}}]}, {"_and": [{"reporters": {"is_me": True}}, {"state": {"_eq": "public_mode"}}]}]}]}}}
print("Start request 1")
response = requests.post(burp0_url, headers=burp0_headers, json=burp0_json)
print("Response")
handles = []

data = json.loads(response.content)
for i in data["data"]["query"]["_teamsK4Kj0"]["edges"]:
	node = i["node"]
	handles.append(node["handle"])


typeset = handlers()
for handle in handles:
	if handle in program_blacklist:
		continue
	if handle not in typeset:
		typeset.add(handle, {
			"in_scope": {},
			"out_scope": {}
		})
	# print(typeset)
	print("Start processing handle: %s" % handle)
	burp0_json={"query": "query Team_assets($first_0:Int!) {query {id,...F0}} fragment F0 on Query {me {_membership4r8hqi:membership(team_handle:\"%s\") {permissions,id},id},_teamBlFQc:team(handle:\"%s\") {handle,_structured_scope_versions2ZWKHQ:structured_scope_versions(archived:false) {max_updated_at},_structured_scopes2qeKP8:structured_scopes(first:$first_0,archived:false,eligible_for_submission:true) {edges {node {id,asset_type,asset_identifier,rendered_instruction,max_severity,eligible_for_bounty},cursor},pageInfo {hasNextPage,hasPreviousPage}},_structured_scopes1wWN6h:structured_scopes(first:$first_0,archived:false,eligible_for_submission:false) {edges {node {id,asset_type,asset_identifier,rendered_instruction},cursor},pageInfo {hasNextPage,hasPreviousPage}},id},id}" % (handle, handle), "variables": {"first_0": 500}}
	response = requests.post(burp0_url, headers=burp0_headers, json=burp0_json)
	data = json.loads(response.content)
	print(data["data"]["query"]["_teamBlFQc"])
	
	for item in data["data"]["query"]["_teamBlFQc"]["_structured_scopes2qeKP8"]["edges"]:
		node = item["node"]
		if node["asset_type"] not in typeset[handle]["in_scope"]:
			typeset[handle]["in_scope"][node["asset_type"]] = []
		
		typeset[handle]["in_scope"][node["asset_type"]].append(node["asset_identifier"])
	for item in data["data"]["query"]["_teamBlFQc"]["_structured_scopes1wWN6h"]["edges"]:
		node = item["node"]
		if node["asset_type"] not in typeset[handle]["out_scope"]:
			typeset[handle]["out_scope"][node["asset_type"]] = []
		
		typeset[handle]["out_scope"][node["asset_type"]].append(node["asset_identifier"])

for handle in typeset:
	#~ print(handle)
	for scope in typeset[handle]:
		for key in typeset[handle][scope]:
			call_func = "process"+key 
			if call_func in function_list:
				if handle not in program_blacklist:
					function_list[call_func](handle, scope, key, typeset[handle][scope][key])
			#~ print(key)
			#~ print("____________________________________________")
			#~ for value in typeset[handle][key]:
				#~ print(value)
			#~ print("____________________________________________")
			#~ print("____________________________________________")
			#~ print("____________________________________________")
