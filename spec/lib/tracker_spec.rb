require "spec_helper"
require "tracker"

module Colissimo
  describe Tracker do

    before(:each) do
      @client = MiniTest::Mock.new
    end

    describe "#tracking_rows" do
      it "should not raise if no tracking_code given" do
        @client.expect :get_content, "", [String]

        tracker = Colissimo::Tracker.new nil, @client
        tracker.tracking_rows.must_be_empty
      end

      it "should parse Colissimo HTML and find 8 rows" do
        parse_6C07437595437

        tracker = Colissimo::Tracker.new "6C07437595437", @client
        rows = tracker.tracking_rows
        rows.size.must_equal 8
      end

      it "should parse Colissimo HTML and keep only the first row" do
        parse_6C07437595437

        tracker = Colissimo::Tracker.new "6C07437595437", @client
        rows = tracker.tracking_rows :latest_only => true
        rows.size.must_equal 1
      end

      it "should read date, label and localization from tracked row" do
        parse_6C07437595437
        tracker = Colissimo::Tracker.new "6C07437595437", @client
        row = tracker.tracking_rows(:latest_only => true).first

        @client.expect :get_content, "000000", [String]
        row.date.must_equal "000000"
        row.date_base64_png.must_equal "data:image/png;base64,MDAwMDAw"

        @client.expect :get_content, "111111", [String]
        row.label.must_equal "111111"
        row.label_base64_png.must_equal "data:image/png;base64,MTExMTEx"

        @client.expect :get_content, "222222", [String]
        row.localization.must_equal "222222"
        row.localization_base64_png.must_equal "data:image/png;base64,MjIyMjIy"
      end

      private

      def parse_6C07437595437
        body = File.read("spec/support/6C07437595437.html", :encoding => 'iso-8859-1')
        @client.expect :get_content, body, [String]
      end
    end
  end
end