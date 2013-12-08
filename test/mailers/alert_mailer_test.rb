require 'test_helper'

class AlertMailerTest < ActionMailer::TestCase
  test "match" do
    mail = AlertMailer.match
    assert_equal "Match", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "summary" do
    mail = AlertMailer.summary
    assert_equal "Summary", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
