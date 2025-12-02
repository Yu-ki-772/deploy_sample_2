class DiagnosesController < ApplicationController
  skip_before_action :require_login, only: %i[start]
  def start
  end

  def questions
  end

  def result
  end
end
