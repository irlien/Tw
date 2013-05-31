require 'csv'

require 'twitter'

Twitter.configure do |config|
  config.consumer_key = ''
  config.consumer_secret = ''
  config.oauth_token = ''
  config.oauth_token_secret = ''
end

def all_list_members(list_owner_username, slug)
  users = []
  cursor = -1
  while cursor.nonzero?
    response = Twitter.list_members(list_owner_username, slug, :cursor => cursor)
    users += response.users
    cursor = response.next_cursor
  end
  users
end

def all_friends(user)
  users = []
  cursor = -1
  while cursor.nonzero?
    response = Twitter.friends(user, :cursor => cursor)
    users += response.users
    cursor = response.next_cursor
  end
  users
end

CSV.open('list.csv', 'w') do |csv|
  csv << %w(ID Name ScreenName Location Description URL)
  all_list_members('verified', 'politics').each do |user|
    url = user.attrs[:entities][:url]
    csv << [
      user.id,
      user.screen_name,
      user.name,
      user.location,
      user.description,
      url && url[:urls][0][:expanded_url],
    ]
  end
end
