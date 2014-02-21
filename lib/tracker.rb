require "httpclient"
require "nokogiri"
require "base64"

module Colissimo
  ROOT_PATH = "http://www.colissimo.fr/portail_colissimo/"
  TRACKING_ENDPOINT = "suivre.do?colispart="

  class Tracker
    def initialize(shipping_code, http_client = nil)
      @shipping_code = shipping_code
      @http_client = http_client || HTTPClient.new
    end

    # Options:
    #   - latest_only: Retrieve only the latest tracking status (first row)
    def tracking_rows(options = {})
      body = @http_client.get_content tracking_url
      doc = Nokogiri::HTML(body)
      tracking_images(doc, options)
    end

    private

    def tracking_url
      "#{ROOT_PATH}#{TRACKING_ENDPOINT}#{@shipping_code}"
    end

    def tracking_images(doc, options)
      options[:latest_only] ||= false

      rows = doc.css("#resultatSuivreDiv .dataArray > tbody > tr")
      rows = [ rows.first ] if options[:latest_only]

      rows.collect do |row|
        images = row.css("td img").collect do |img|
           "#{ROOT_PATH}#{img.attr("src").strip}"
        end
        Row.new images, @http_client
      end
    end

    class Row
      def initialize(images, http_client)
        @date_src = images[0]
        @label_src = images[1]
        @localization_src = images[2]
        @http_client = http_client
      end

      %w(date label localization).each do |property|
        define_method(property) do
          unless instance_variable_defined? "@#{property}"
            image = instance_variable_get "@#{property}_src"
            instance_variable_set "@#{property}", @http_client.get_content(image)
          end
          instance_variable_get "@#{property}"
        end

        define_method("#{property}_base64_png") do
          base64_png(self.send property.to_sym)
        end
      end

      private

      def base64_png(image)
        "data:image/png;base64,#{Base64.encode64(image).strip}" unless image.nil?
      end
    end

  end
end
