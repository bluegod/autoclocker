# frozen_string_literal: true

require 'rubygems'
require 'faraday'
require 'faraday_middleware'

module Api
  class Auth
    def to_hash
      @config = Config.instance
      response = token_conn.get('me')
      data = response.body['data']

      { name: data['firstname'], id: data['linkedEe'], token_conn: @token_conn }
    end

    private

    def token_conn
      @token_conn ||=
        Faraday.new(@config.default.api_url) do |builder|
          builder.headers['Authorization'] = token
          builder.request :json
          builder.adapter Faraday.default_adapter
          builder.response :logger, SemanticLogger['Auth']
          builder.response :json, content_type: /\bjson$/
        end
    end

    def login_conn
      Faraday.new(url: @config.default.api_login_url) do |builder|
        builder.request :retry
        builder.request :json
        builder.adapter Faraday.default_adapter
        builder.response :logger, SemanticLogger['Auth']
        builder.response :json, content_type: /\bjson$/
      end
    end

    def token
      response = login_conn.post do |request|
        request.body = { email: @config.user, password: @config.password }
      end

      response.body['data']['token']
    end
  end
end
