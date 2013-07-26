class Alert < ActiveRecord::Base
  attr_accessible :url, :phones
  has_and_belongs_to_many :phones
  before_save :set_status_to_live

  def self.send_all_alerts
    alerts = Alert.all.each
    alerts.each do |a|
      a.trigger_sms_alert
    end
  end

  def trigger_sms_alert
    if gone_down?
      send_sms_to_all_phones
    end
    update_status
  end
  
  def gone_down?
    self.status == 1 and live_status == -1
  end

  def live_status
    uri = URI.parse(self.url)
    response = Net::HTTP.get_response(uri)
    if response.code[0] == "2"
      1
    else
      -1
    end
  end

  def set_status_to_live
    self.status = live_status

  end
  def update_status
    self.status = live_status
    self.save
  end

  def send_sms_to_all_phones
    self.phones.each do |p|
      send_sms(p.phone_number)
    end
  end

  def send_sms(phone_number)
    sid = ENV['ACCOUNT_SID']
    auth_token = ENV['AUTH_TOKEN']
    from_number = ENV['TWIL_NUMBER']

    @client = Twilio::REST::Client.new sid, auth_token

    @client.account.sms.messages.create(
    :from => from_number,
    :to => phone_number,
    :body => "Yo shit broke! #{self.url}"
    )
  end
end