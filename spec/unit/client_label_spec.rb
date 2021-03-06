require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Sift::Client do

  def valid_label_properties
    {
      :$reasons => [ "$fake" ],
      :$is_bad => true,
      :$description => "Listed a fake item"
    }
  end

  def fully_qualified_users_labels_endpoint(user_id)
    Sift::Client::API_ENDPOINT + Sift.current_users_label_api_path(user_id)
  end

  it "Successfuly handles a $label with the v203 API and returns OK" do

    response_json = { :status => 0, :error_message => "OK" }
    user_id = "frodo_baggins"

    stub_request(:post, "https://api.siftscience.com/v203/users/frodo_baggins/labels").
      with(:body => '{"$reasons":["$fake"],"$is_bad":true,"$description":"Listed a fake item","$type":"$label","$api_key":"foobar"}').
      to_return(:body => MultiJson.dump(response_json), :status => 200, :headers => 
        {"content-type"=>"application/json; charset=UTF-8","content-length"=> "74"})

    api_key = "foobar"
    properties = valid_label_properties

    response = Sift::Client.new(api_key).label(user_id, properties)
    expect(response.ok?).to eq(true)
    expect(response.api_status).to eq(0)
    expect(response.api_error_message).to eq("OK")
  end

  it "Successfully handles an $unlabel with the v203 API endpoing and returns OK" do
    response_json = { :status => 0, :error_message => "OK" }
    user_id = "frodo_baggins"

    stub_request(:delete, "https://api.siftscience.com/v203/users/frodo_baggins/labels?api_key=foobar").
      to_return(:status => 204)

    api_key = "foobar"

    response = Sift::Client.new(api_key).unlabel(user_id)
    expect(response.ok?).to eq(true)
  end

end
