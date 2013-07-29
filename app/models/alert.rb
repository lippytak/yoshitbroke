class Alert < ActiveRecord::Base
  attr_accessible :url, :phones, :phones_attributes
  has_and_belongs_to_many :phones
  before_validation :format_url
  validates_format_of :url, :with => URI::regexp(%w(http https))
  before_save :set_status_to_live
  accepts_nested_attributes_for :phones

  def format_url
    self.url = "http://#{self.url}" unless self.url[/^https?/]
  end

  def self.send_all_alerts
    alerts = Alert.all.each
    alerts.each do |a|
      a.trigger_sms_alert
    end
  end

  def trigger_sms_alert
    if gone_down?
      send_sms_to_all_phones('down')
    elsif back_up?
      send_sms_to_all_phones('up')
    end
    update_status
  end
  
  def gone_down?
    self.status == 1 and live_status == -1
  end

  def back_up?
    self.status == -1 and live_status == 1
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

  def send_sms_to_all_phones(flag)
    if flag == 'down'
      body = "Yo shit broke! #{self.url}"
      puts body
    else flag == 'up'
      body = "Yo everything is cool! #{self.url}"
      puts body
    end
    self.phones.each do |p|
      send_sms(p.phone_number, body)
    end
  end

  def send_sms(phone_number, body)
    sid = ENV['ACCOUNT_SID']
    auth_token = ENV['AUTH_TOKEN']
    from_number = ENV['TWIL_NUMBER']
    body = helper.truncate(body, length: 160)

    @client = Twilio::REST::Client.new sid, auth_token

    @client.account.sms.messages.create(
    :from => from_number,
    :to => phone_number,
    :body => body
    )
  end
end