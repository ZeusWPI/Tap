unless Rails.env.production?
  require 'factory_girl'
  require 'faker'
  task :sow => :environment do
    # FactoryGirl.create_list(:user, 20)
    FactoryGirl.create_list(:product, 20)
  end
end
