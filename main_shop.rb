#------------------------------------------------------------
# Filename: main_shop.rb
# Description: Amaysim Shopping Cart Exercise
# 
# Author: Darlene Joy C. Masong
# Date: January 18, 2017
#------------------------------------------------------------

# Product class
class Product
  attr_accessor :product_code, :product_name, :price
  
  # initialize instance variables
  def initialize(product_code, product_name, price)
    @product_code = product_code
    @product_name = product_name
    @price = price
  end
end

# Shopping cart class
class ShoppingCart
  attr_accessor :pricing_rules, :cart_items, :promo_code
  
  # initialize instance variables
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @cart_items = Array.new
    @promo_code = ""
  end
  
  # add cart item
  def add(item_code, promo_code="")
    @cart_items << pricing_rules.select{|p| p.product_code == item_code}.first
    @promo_code = promo_code unless promo_code.empty?
  end
  
  # compute and display the cart total
  def total
    # group cart items by product type
    group_items
    
    # compute ult_small sims
    #   with 3 for 2 deal on Unlimited 1GB Sims
    small_total = 0
    unless @ult_small.empty?
      # get price from pricing_rules
      price = @pricing_rules.select{|p| p.product_code == @ult_small.first.product_code}.first.price
      
      # promo for every 3 items
      small_promo = (@ult_small.length / 3) * (2 * price)
      
      # normal price for remaining < 3 items
      small_normal = (@ult_small.length % 3) * price
      small_total = small_promo + small_normal
    end
    
    # compute ult_medium sims
    #   bundle 1GB Data-pack for free for every Unlimited 2GB Sim
    #   get count of free 1GB Data-pack
    medium_total = 0
    free_1gb_count = 0
    unless @ult_medium.empty?
      price = @pricing_rules.select{|p| p.product_code == @ult_medium.first.product_code}.first.price
      free_1gb_count = @ult_medium.length
      medium_total = @ult_medium.length * price
    end
    
    # compute ult_large sims
    #   bulk discount if customer buys > 3
    large_total = 0
    unless @ult_large.empty?
      price_drop = 39.9
      price = @pricing_rules.select{|p| p.product_code == @ult_large.first.product_code}.first.price
      if @ult_large.length > 3
        price = price_drop
      end
      large_total = @ult_large.length * price
    end
    
    # compute 1gb data-pack sims
    #   bundle 1GB Data-pack for free for every Unlimited 2GB Sim
    #   don't include free 1GB Data-pack in the total
    data_1gb_total = 0
    unless @data_1gb.empty?
      price = @pricing_rules.select{|p| p.product_code == @data_1gb.first.product_code}.first.price
      data_1gb_total = (@data_1gb.length - free_1gb_count) * price
    end
    
    # total the grouped items
    total = small_total + medium_total + large_total + data_1gb_total
    
    # apply 10% discount if applied promo_code 'I<3AMAYSIM'
    #   gets the last promo_code entered
    if @promo_code == "I<3AMAYSIM"
      total = total - (total * 0.1)
    end
    
    # display to console (show the cart total to user)
    puts "$#{'%.02f' % total}"
  end
  
  # get and display the cart items added
  def items
    # group cart items by product type
    group_items
    
    # display ult_small sims
    if @ult_small.length > 0
      puts "#{@ult_small.length} X #{@ult_small.first.product_name}"
    end
    
    # display ult_medium sims
    if @ult_medium.length > 0
      puts "#{@ult_medium.length} X #{@ult_medium.first.product_name}"
    end
    
    # display ult_large sims
    if @ult_large.length > 0
      puts "#{@ult_large.length} X #{@ult_large.first.product_name}"
    end
    
    # display 1gb data-pack sims
    if @data_1gb.length > 0
      puts "#{@data_1gb.length} X #{@data_1gb.first.product_name}"
    end
  end
  
  # group cart items by product type
  def group_items
    @ult_small = Array.new
    @ult_medium = Array.new
    @ult_large = Array.new
    @data_1gb = Array.new
    
    data_1gb_item = @pricing_rules.select{|p| p.product_code == "1gb"}.first
    
    @cart_items.each do |item|
      case item.product_code
      when "ult_small" then @ult_small << item
      when "ult_medium" then
        @ult_medium << item
        @data_1gb << data_1gb_item
      when "ult_large" then @ult_large << item
      when "1gb" then @data_1gb << item
      else
        # do nothing
      end
    end
  end
end

# Main shop class
class MainShop
  # List of products with prices
  @products = Array.new
  @products << Product.new("ult_small", "Unlimited 1GB", 24.90)
  @products << Product.new("ult_medium", "Unlimited 2GB", 29.90)
  @products << Product.new("ult_large", "Unlimited 5GB", 44.90)
  @products << Product.new("1gb", "1 GB Data-pack", 9.90)
  
  # Initialize new shopping cart
  cart = ShoppingCart.new(@products)
  done = false
  ctr = 0
  
  # display instructions to user
  puts
  puts "Please select items using their assigned number."
  puts "Enter 'x' when you're done adding items."
  puts
  
  # display product choices
  puts "--------- PRODUCTS ---------"
  cart.pricing_rules.each do |prod|
    puts "#{ctr += 1} : #{prod.product_name} ($#{prod.price})"
  end
  puts "----------------------------"
  puts
  
  # accept input until the user exits
  while !done do
    print "Item: "
    input = gets.chomp
    
    if input == "x"
      done = true
    else
      case input
      when "1" then item = cart.pricing_rules.first.product_code
      when "2" then item = cart.pricing_rules[1].product_code
      when "3" then item = cart.pricing_rules[2].product_code
      when "4" then item = cart.pricing_rules.last.product_code
      else
        item = nil
      end
      
      unless item == nil
        print "Promo Code: "
        promo_code = gets.chomp
        
        # add item to cart
        #   the last promo_code input will be used in computing the cart total
        cart.add(item, promo_code)
      else
        puts "Invalid item selected."
      end
    end
  end
  
  # Display cart total to user
  puts "\nCart Total:"
  cart.total
  
  # Display cart items to user
  puts "\nCart Items:"
  cart.items
  puts
end
