namespace :token do
  desc "Create an API access token"

  task create: :environment do
    token = ApiKey.create!.access_token
    $stdout.write "#{token}\n"
  end

  task clear: :environment do
    ApiKey.delete_all
  end

end
