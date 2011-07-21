require 'test_helper'

class ChangeNotificationsTest < ActionMailer::TestCase
  test "changes" do
    mail = ChangeNotifications.changes
    assert_equal "Changes", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
