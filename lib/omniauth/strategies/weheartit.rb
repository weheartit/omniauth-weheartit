require 'omniauth-oauth2'

OmniAuth.config.add_camelization('weheartit', 'WeHeartIt')

module OmniAuth
  module Strategies
    class WeHeartIt < OmniAuth::Strategies::OAuth2
      option :name, :weheartit

      option :client_options, {
        :site => "https://api.weheartit.com",
        :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          name:  raw_info["name"],
          email: raw_info["email"],
          staff: raw_info["staff"],
          nickname: raw_info["username"],
          location: raw_info["location"],
          description: raw_info["bio"],
          image: get_avatar(:large),
          urls: get_urls,
        }
      end

      extra do
        {
          raw_info: raw_info
        }
      end

      def raw_info
        access_token.options[:param_name] = :access_token
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get(profile_info_path).parsed
      end

      private

      def get_urls
        {
          "weheartit" => "https://www.weheartit.com/#{raw_info["username"]}",
          "personal" => raw_info["link"],
        }
      end

      def get_avatar(style = :large)
        style = style.to_s
        raw_info["avatar"].find do |avatar_hash|
          avatar_hash['style'] == style
        end['url']
      end

      def profile_info_path
        "/api/v2/user"
      end
    end
  end
end
