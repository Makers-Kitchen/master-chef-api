require 'net/http'
result = Net::HTTP.get(URI.parse('https://slack.com/api/users.profile.get?token=xoxp-394441928593-394981941026-516554471987-63bc71212b6a8042e07cc331ac84dd70&include_labels=true&user=UBLUVTP0S'))
p result 
