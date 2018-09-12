def consolidate_cart(cart:[])
  result = {}
  # code here
  cart.each_with_index do |item, i|
    item.each do |food, info|
      if result[food]
        result[food][:count] += 1
      else
        result[food] = info
        result[food][:count] = 1
      end
    end
  end
  result
end



def apply_coupons(cart:[], coupons:[])
  result = {}
  # code here#
  cart.each do |food, info|
    coupons.each do |coupon|
      if food == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] =  info[:count] - coupon[:num]
        if result["#{food} W/COUPON"]
          result["#{food} W/COUPON"][:count] += 1
        else
          result["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
    result[food] = info
  end
  result
end

def apply_clearance(cart:[])
  clearance_cart = {}
  # code here
  cart.each do |food, info|
    clearance_cart[food] = {}
    if info[:clearance] == true
      clearance_cart[food][:price] = info[:price] * 4 / 5
    else
      clearance_cart[food][:price] = info[:price]
    end
    clearance_cart[food][:clearance] = info[:clearance]
    clearance_cart[food][:count] = info[:count]
  end
  clearance_cart
end

=begin
### The `checkout` method
Create a `checkout` method that calculates the total cost of the consolidated cart.
When checking out, follow these steps *in order*:
* Apply coupon discounts if the proper number of items are present.
* Apply 20% discount if items are on clearance.
* If, after applying the coupon discounts and the clearance discounts, the cart's total is over $100, then apply a 10% discount.
### Named Parameters
The method signature for the checkout method is
`consolidate_cart(cart:[])`. This, along with the checkout method uses a ruby 2.0 feature called [Named Parameters](http://brainspec.com/blog/2012/10/08/keyword-arguments-ruby-2-0/).
Named parameters give you more expressive code since you are specifying what each parameter is for. Another benefit is the order you pass your parameters doesn't matter!
`checkout(cart: [], coupons: [])` is the same as `checkout(coupons: [], cart: [])`
=end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)
  result = 0
  cart.each do |food, info|
    result += (info[:price] * info[:count]).to_f
  end
  result > 100 ? result * 0.9 : result
end

def apply_coupons(cart, coupon)
    coupon.each do |item|
    name_of_item = item[:item]
    if cart.has_key?(name_of_item) == true && cart[name_of_item][:count] >= item[:num]
      cart[name_of_item][:count] = cart[name_of_item][:count] - item[:num]
      new_item = name_of_item + (" W/COUPON")
      puts cart.has_key?(new_item)
      if cart.has_key?(new_item) == false
        cart[new_item] = {:price => item[:cost], :clearance => cart[name_of_item][:clearance], :count => 1}
      else 
        cart[new_item][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, details|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price]*0.20 - total)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  
  if cart.length == 1
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    if cart_clearance.length > 1
      cart_clearance.each do |item, details|
        if details[:count] >=1
          total += (details[:price]*details[:count])
        end
      end
    else
      cart_clearance.each do |item, details|
        total += (details[:price]*details[:count])
      end
    end
  else
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    cart_clearance.each do |item, details|
      total += (details[:price]*details[:count])
    end
  end
  

  if total > 100
    total = total*(0.90)
  end
  total
end
