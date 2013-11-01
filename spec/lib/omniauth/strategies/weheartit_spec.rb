# encoding: UTF-8
require "spec_helper"

describe OmniAuth::Strategies::WeHeartIt do
  let(:app){ Rack::Builder.new do |b|
    b.use Rack::Session::Cookie, {:secret => "abc123"}
    b.run lambda{|env| [200, {}, ['Not Found']]}
  end.to_app }

  let(:request) { double('Request').stub(params: {}, cookies: {}, env: {}) }
  let(:session) { double('Session')..stub(:delete).with('omniauth.state').and_return('state') }

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  subject do
    OmniAuth::Strategies::WeHeartIt.new(app,"client_id", "client_secret").tap do |strategy|
      strategy.stub(:request) { request }
    end
  end

  context "request phase" do
    before(:each){ get '/auth/weheartit' }

    it "authenticate" do
      expect(last_response.status).to eq(200)
    end
  end

  describe "callback phase" do
    let(:raw_info) do
      {
        "id" => 2651358,
        "username" => "nhocki",
        "name" => "Nicolás Hock Isaza",
        "email" => "juan@weheartit.com",
        "location" => "San Francisco and Medellin",
        "bio" => "I work here!",
        "link" => "http://nhocki.com",
        "avatar" =>
          [
            { "style" => "large", "url" => "http://data-dev.whicdn.com/avatars/1/thumb.png" },
            { "style" => "thumb", "url" => "http://data-dev.whicdn.com/avatars/1/large.png" },
          ],
        "cover" => {
          "url" => "http://weheartit.com/cover/123.png",
          "entry_id" => 1,
          "cropping" => { },
        },
        "hearts_count" => 685,
        "following_count" => 70,
        "followers_count" => 209,
        "sets_count" => 13,
        "public_account" => true,
        "verified" => true,
        "staff" => true,
        "created_at" => "2012-05-03T21:44:58Z",
      }
    end

    before :each do
      subject.stub(:raw_info) { raw_info }
    end

    context "info" do
      it 'returns the uid (required)' do
        subject.uid.should eq(raw_info['id'])
      end

      it 'returns the name (required)' do
        subject.info[:name].should eq(raw_info['name'])
      end

      it 'returns the email' do
        subject.info[:email].should eq(raw_info['email'])
      end

      it "returns if the user is staff" do
        subject.info[:staff].should eq(raw_info['staff'])
      end

      it "returns the nickname" do
        subject.info[:nickname].should eq(raw_info['username'])
      end

      it "returns the location" do
        subject.info[:location].should eq(raw_info['location'])
      end

      it "returns the user's description" do
        subject.info[:description].should eq(raw_info['bio'])
      end

      it "returns the large avatar as image url" do
        subject.info[:image].should eq('http://data-dev.whicdn.com/avatars/1/thumb.png')
      end

      it "returns an array of urls" do
        subject.info[:urls].should have(2).items
      end
    end
  end

  context "get token" do
    before :each do
      @access_token = double('OAuth2::AccessToken')
      @access_token.stub(:token)
      @access_token.stub(:expires?)
      @access_token.stub(:expires_at)
      @access_token.stub(:refresh_token)
      subject.stub(:access_token) { @access_token }
    end

    it 'returns a Hash' do
      subject.credentials.should be_a(Hash)
    end

    it 'returns the token' do
      @access_token.stub(:token) {
        {
          :access_token => "OTqSFa9zrh0VRGAZHH4QPJISCoynRwSy9FocUazuaU950EVcISsJo3pST11iTCiI",
          :token_type => "bearer"
        } }
      subject.credentials['token'][:access_token].should eq('OTqSFa9zrh0VRGAZHH4QPJISCoynRwSy9FocUazuaU950EVcISsJo3pST11iTCiI')
      subject.credentials['token'][:token_type].should eq('bearer')
    end
  end
end
