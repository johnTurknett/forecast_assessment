class Api::BaseController < ApplicationController
  before_action :validate_token

  private

  def validate_token
    # TODO: Make sure the token is valie
    # raise exception if it is not valid
  end
end
