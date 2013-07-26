class Alert < ActiveRecord::Base
  attr_accessible :url, :owner_phone
  
  def self.send_all_alerts
    alerts = Alert.all.each
    alerts.each do |a|
      a.trigger_sms_alert
    end
  end

  def trigger_sms_alert
    if gone_down?
      send_sms
    end
    update_status
  end
  
  def gone_down?
    self.status == 1 and live_status == -1
  end

  def live_status
    uri = URI.parse(self.url)
    response = Net::HTTP.get_response(uri)
    cd = response.code
    if cd[0] == "2"
      1
    else
      -1
    end
  end

  def update_status
    self.status = live_status
  end

  def send_sms
    sid = ENV['ACCOUNT_SID']
    auth_token = ENV['AUTH_TOKEN']
    from_number = ENV['TWIL_NUMBER']

    @client = Twilio::REST::Client.new sid, auth_token

    @client.account.sms.messages.create(
    :from => from_number,
    :to => owner_phone,
    :body => "Yo shit broke! #{self.url}"
    )
  end
  
end