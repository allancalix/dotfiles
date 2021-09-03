set IP 'https://api.ipify.org/?format=json'

function pubip
  curl "$IP" 2> /dev/null | jq -r '.ip'
end
