class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :styleguide]

  def index
  end

  def styleguide
  end
end
