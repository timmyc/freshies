class Dispatch < Struct.new(:alert_id)
  def perform
    alert = Alert.find(alert_id)
    alert.send_message
  end
end
