# frozen_string_literal: true

require 'elasticsearch/transport/transport/serializer/multi_json'
require 'elasticsearch/transport/transport/base'
require 'elasticsearch/transport/transport/http/faraday'
require 'elasticsearch/transport/request'
require 'aws-sigv4'

module Elasticsearch
  module Transport
    # Signature Version 4 Elasticsearch Transport for AWS Elasticsearch Service
    class AWS4 < Elasticsearch::Transport::Transport::HTTP::Faraday
      HEADERS = %w[
        host
        x-amz-date
        x-amz-security-token
        x-amz-content-sha256
        authorization
      ].freeze

      def initialize(arguments = {}, &_block)
        super arguments

        session_token_service = Aws::STS::Client.new(access_key_id: arguments[:options][:aws4][:key],
                                                      secret_access_key: arguments[:options][:aws4][:secret])
        session = session_token_service.get_session_token

        @signer = Aws::Sigv4::Signer.new(
          access_key_id: session.credentials[:access_key_id],
          secret_access_key: session.credentials[:secret_access_key],
          service: 'es',
          region: arguments[:options][:aws4][:region],
          session_token: session.credentials[:session_token]
        )
      end

      def perform_request(method, path, params = {}, body = nil, headers=nil)
        Elasticsearch::Transport::Transport::Base.instance_method(:perform_request)
          .bind(self).call(method, path, params, body) do |connection, url|
          connection.connection.run_request(
            method.downcase.to_sym, url, (body ? __convert_to_json(body) : ''), {}
          ) do |request|
            signature = @signer.sign_request(
              url: url, http_method: request.method, headers: request.headers, body: request.body
            )

            HEADERS.each { |header| request.headers[header] = signature.headers[header] || '' }
          end
        end
      end
    end
  end
end
