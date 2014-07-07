Paperclip.interpolates :last_audit_id do |attachment, style|
  attachment.instance.last_audit.id
end
