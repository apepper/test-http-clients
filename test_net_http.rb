
class TestNetHttp < BaseTest
  def initialize
    super
    require "net/http"
    @req = Net::HTTP::Get.new(URL_PATH)
    @req.add_field("X-Test", "test")
    @conn = Net::HTTP.new(URL_HOST, URL_PORT)
    if URL.scheme == 'https'
      @conn.use_ssl = true
      @conn.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
    @conn.start
  end
  def bench
    resp = @conn.request(@req)
    verify_response(resp.body)
  end
end

test_http("net/http", TestNetHttp)
