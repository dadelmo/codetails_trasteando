
require 'test_helper'

class UserComplianceTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = User.new
  end

end
