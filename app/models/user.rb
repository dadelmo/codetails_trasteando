class User < JsonStore

  include ActiveModel::Conversion

  extend ActiveModel::Naming

  extend ActiveModel::Translation

  include ActiveModel::Validations

  attr_accessor :name

  validates :name, presence: true
end
