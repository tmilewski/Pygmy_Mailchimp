require 'xmlrpc/client'

class Pygmy_Mailchimp
  def initialize
    load_config
    login
    return self
  end
  
  def load_config
    config = YAML.load(File.open("#{RAILS_ROOT}/config/pygmy_mailchimp.yml"))[RAILS_ENV].symbolize_keys
    @username  = config[:username].to_s
    @password  = config[:password].to_s
    @list_id = config[:default_list_id].to_s
  end
  
  # Login to MailChimp
  def login
    begin
      @api ||= XMLRPC::Client.new2('http://api.mailchimp.com/1.2/')
      @api_key = @api.call('login', @username, @password)
    rescue
      puts "MailChimp Login Error"
    end
  end
  
  # Find Mailing List ID
  def find_list_id(list_name)
    begin
      mailing_lists = @api.call("lists", @api_key)
      @list = mailing_lists.find {|list| list["name"] == list_name} unless mailing_lists.nil?
      @list_id = @list['id']
    rescue
      return nil
    end
  end
  
  # Subscribe to Mailing List
  def subscribe(email, user_info = {}, email_type = "html", update_existing = true, double_opt = false)
    begin
      @api.call("listSubscribe", @api_key, @list_id, email, user_info, email_type, double_opt, update_existing, false)
    rescue
      false
    end
  end
  
  # Unsubscribe from Mailing List
  def unsubscribe(current_email, send_goodbye = false, send_notification = false)
    begin
      @api.call("listUnsubscribe", @api_key, @list_id, current_email, true, send_goodbye, send_notification)
    rescue
      false
    end
  end
  
  # Update Member of Mailing List
  def update(current_email, user_info, email_type = 'html')
    begin
      @api.call("listUpdateMember", @api_key, @list_id, current_email, user_info, email_type, true)
    rescue
      false
    end
  end
end