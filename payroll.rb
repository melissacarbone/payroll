require 'csv'
require 'pry'

class Employee
attr_accessor :last_name

  def self.read_employees(filename)
    employees = []
    CSV.foreach(filename, headers:true) do |row|
      if row["job title"] == "commission sales person"
        employees << CommissionSalesPerson.new(row["last name"], row["base salary"].to_f, row["job title"], row["commission"].to_f, row["quota"].to_f, row["bonus"].to_f)
      elsif row["job title"] == "quota based sales person"
        employees << QuotaSalesPerson.new(row["last name"], row["base salary"].to_f, row["job title"], row["commission"].to_f, row["quota"].to_f, row["bonus"].to_f)
      elsif row["job title"] == "owner"
        employees << Owner.new(row["last name"], row["base salary"].to_f, row["job title"], row["commission"].to_f, row["quota"].to_f, row["bonus"].to_f)
      else
        employees << Employee.new(row["last name"], row["base salary"].to_f, row["job title"], row["commission"].to_f, row["quota"].to_f, row["bonus"].to_f)
      end
    end
    employees
  end





  def initialize(last_name, base_salary, job_title, commission=nil, quota=nil, bonus=nil)
    @last_name = last_name
    @base_salary = base_salary
    @job_title = job_title
    @commission = commission
    @quota = quota
    @bonus = bonus
  end

  def to_s
    "#{self.class} = class
    #{@last_name} = last_name
    #{@base_salary} = base_salary
    #{@job_title} = job_title
    #{@commission} = commission
    #{@quota} = quota
    #{@bonus} = bonus"
  end

  def net_pay
    @base_salary-(0.3*@base_salary)
  end

  def gross_salary
    @base_salary
  end
end

class CommissionSalesPerson < Employee
  #an array of a particular salesperson's sale objects
  attr_accessor :sales
  def find_sales(sales)
    @sales = []
    sales.each do |sale|
      if self.last_name == sale.last_name
        @sales << sale
      end
    end
    @sales
  end

  def gross_salary
    total = 0.0
    @sales.each do |sale|
      total += sale.sale_value
    end
    @base_salary+(@commission*total)
  end
end

class QuotaSalesPerson < Employee
  attr_accessor :sales
  def find_sales(sales)
    @sales = []
    sales.each do |sale|
      if self.last_name == sale.last_name
        @sales << sale
      end
    end
    @sales
  end

  def gross_salary
    total = 0.0
    @sales.each do |sale|
      total += sale.sale_value
    end
    if total > @quota
      @base_salary + @bonus
    else
      @base_salary
    end
  end
end

class Owner < Employee

  def bonus?(sales)
    total = 0.0
    sales.each do |sale|
      total += sale.sale_value
    end
    if total>250000
      true
    else
      false
    end
  end

  def gross_salary(sales)
    if bonus?(sales)
      @base_salary + 1000
    else
      @base_salary
    end
  end
end

class Sale
  attr_accessor :last_name, :sale_value

  def self.read_sales(filename)
    sales = []
    CSV.foreach(filename, headers:true) do |row|
      sales << Sale.new(row["last_name"], row["gross_sale_value"].to_f)
    end
    sales
  end

  def initialize(last_name, sale_value)
    @last_name = last_name
    @sale_value = sale_value
  end
end

employees = Employee.read_employees('employees.csv')
sales =  Sale.read_sales('sales.csv')


#employees.each {|employee| puts employee}

puts employees[6].find_sales(sales)
puts employees[2].sales
puts employees[7].gross_salary(sales)