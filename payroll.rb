class Employee
  @@taxrate = 0.3

  def self.read_employees(filename)
    @filename = filename
  end

  def initialize(last_name, base_salary)
    @last_name = last_name
    @base_salary = base_salary
  end

  def net_pay
  end

  def gross_salary
  end
end

class CommissionSalesPerson < Employee
end

class QuotaSalesPerson < Employee
end

class Owner < Employee
end

class Sales

  def self.read_sales(filename)
    @filename = filename
  end

  def initialize(last_name, sale_value)
    @last_name = last_name
    @sale_value = sale_value
end