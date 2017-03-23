require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data =
      { "id" => "905772",
        "sharing_settings" => {
          "publish_track_actions" => false,
          "publish_rsvp_actions" => true,
          "notification_settings" => {
            "just_announced" => false,
            "friend_comment" = >true
          }
        }
      }
  end

  test "should update an item" do
    put item_update_url(params: @data)
    assert_response :success
  end

  # test "should create an item" do
  #   post item_create_url(params: @data)
  #   assert_response :success
  # end

end
