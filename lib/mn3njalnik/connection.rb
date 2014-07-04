module Mn3njalnik
  class Connection
    LOGIN_U = "#{BASE_U}/?app=core&module=global&section=login"

    def initialize(options={})
      @browser = Mechanize.new
      @logged_in = false
      @logger = options[:logger]
    end

    def fetch(url, &block)
      @logger.info "GET #{url}" if @logger
      @browser.get(url, &block)
    end

    def login(username, password)
      raise "Already logged in" if logged_in?
      fetch(LOGIN_U) do |page|
        page.form_with(id: "login") do |form|
          form.ips_username = username
          form.ips_password = password
          form.checkbox_with("anonymous").check
        end.submit
      end
      @logged_in = @browser.page.search(".logged_in").any?
    end

    def logged_in?
      @logged_in
    end
  end
end
