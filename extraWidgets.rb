class MyValueBox < Qt::Widget
  def initialize(label)
    super()

    @label = Qt::Label.new(label, self)
    @box = Qt::LineEdit.new(self)

    hbox = Qt::HBoxLayout.new(self) do |i|
        i.addWidget(@label)
        i.addWidget(@box)
    end
  end

  def value(*set)
    case set.length
    when 0
      value = @box.text
      return value
    when 1
      set = set.first
      @box.text = set
    end
  end
end