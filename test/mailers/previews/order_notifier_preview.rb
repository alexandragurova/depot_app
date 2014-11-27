# Preview all emails at http://localhost:3000/rails/mailers/order_notifier
class OrderNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_notifier/received
  def received
    order = Order.second
    items = LineItem.where(order_id: order.id)
    items.each do |item|
      order.line_items << item
    end
    OrderNotifier.received(order)
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_notifier/shipped
  def shipped
    order = Order.second
    items = LineItem.where(order_id: order.id)
    items.each do |item|
      order.line_items << item
    end
    OrderNotifier.shipped(order)
  end

end
