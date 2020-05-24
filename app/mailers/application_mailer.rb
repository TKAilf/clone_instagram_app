class ApplicationMailer < ActionMailer::Base
  # 日本語対応ver
  # default from: 'noreply@example.com',charset: 'ISO-2022-JP'
  # layout 'mailer', charset: "ISO-2022-JP"
  
  #UTF-8 ver
  default from: 'noreply@example.com'
  layout 'mailer'
end
