require 'oj'
require_relative 'application_service'

class ImageScore < ApplicationService
  DEFAULT_SCORE = 0.0
  OK_CODE = 10000
  API_URL = 'https://api.clarifai.com/v2/searches'.freeze

  def initialize(image_url: '', theme: '')
    @image_url = image_url
    @clarifai_token = ENV['CLARIFAI_TOKEN']
    @theme = theme
  end

  def call
    return DEFAULT_SCORE if image_url.empty? || theme.empty? || clarifai_token.nil?
    # TODO delete indexed images
    # TODO fix Bad request error

    indexing_result = index_image
    return DEFAULT_SCORE unless indexing_result.dig('status', 'code') == OK_CODE

    search_result = search_by_concept
    return DEFAULT_SCORE unless search_result.dig('status', 'code') == OK_CODE
    score_from_search_result(search_result)
  end

  private
    attr_accessor :image_url, :clarifai_token, :theme

    def index_image
      ap image_data
      Oj.load(RestClient.post(API_URL, image_data, { 'Content-Type' => 'application/json', 'Authorization' => "Key #{clarifai_token}" }).body)
    end

    def search_by_concept
      ap search_data
      Oj.load(RestClient.post(API_URL, search_data, { 'Content-Type' => 'application/json', 'Authorization' => "Key #{clarifai_token}" }).body)
    end

    def score_from_search_result(search_result)
      search_result.dig('hits' , 'score')
    end

    def image_data
        { inputs: [
              {
                data: {
                  image: {
                    url: image_url
                  }
                }
              }
        ]}.to_json
    end

    def search_data
        { query: {
          ands: [
            {
              output: {
                data: {
                  concepts: [
                    {
                      name: theme
                    }
                  ]
                }
              }
            }
          ]
        } }.to_json
    end

end
