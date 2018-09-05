# frozen_string_literal: true

# Method to returh object with json format and status
module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
