require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data =
      { 'id' => '905772',
        'sharing_settings' => {
          'publish_track_actions' => false,
          'publish_rsvp_actions' => true,
          'notification_settings' => {
            'just_announced' => false,
            'friend_comment' => true
          }
        }
      }

    @url = 'https://gist.githubusercontent.com/fcastellanos/86f02c83a5be6c7a30be390d63057d7d/raw/b25c562a6823a26a700a7ea08004c456ad8e2184/output'
  end

  test 'should not find an item' do
    get find_item_url(id: '905772')
    assert_response :success
  end

  test 'should update an item' do
    put item_update_url(item: @data)
    assert_response :success
  end

  test 'should create an item' do
    post item_create_url(item: @data)
    assert_response :success
  end

  test 'should upload a file' do
    post upload_file_url(url: @url)
    assert_response :success
  end
end
