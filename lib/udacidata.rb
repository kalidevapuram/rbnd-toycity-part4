require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
	@@data_path = File.dirname(__FILE__) + "/../data/data.csv" #giving the file path 
   
  	def self.create(options ={}) #create method creates the product
  		brand = options[:brand]
		name = options[:name]
		price = options[:price]
		product1  = Product.new(brand: brand, name: name, price: price)
		 id = product1.id
		 CSV.open(@@data_path, "ab") do |csv| #opening the CSV file
			csv << [id, brand, name, price]
		end
		return  product1
  	end

  	def self.all #all method returns an array with the all product objects
        products = []
		data = CSV.read(@@data_path).drop(1)
		data.each do |i|
        	products << Product.new(id: i[0], brand: i[1], name: i[2], price: i[3])
        end
        return  products
    end
    
    
	def self.first(n=0) #first method returns the first number of products obejects
		
		products = self.all
		
		if n == 0
		return products[0]
		else
		return products.slice(0, n)
		end
		
		end

	def self.last(n=0) #last method returns the last number of products objects
		products = self.all
		if n == 0
		return products.last
		else
		return products.slice(products.length-n, products.length)
		end
		end
		
	def self.find(n) #finds the number of products
		products = self.all	
		product = products.find{|i| i.id==n}	
		if  product == nil
			raise ProductNotFoundError, " #{n} Id does not exist "
		else	
			return product
		end
		end
	
	def self.myfind(n) #finds the number of products
		products = self.all	
		product = products.find{|i| i.id==n}	
		if  product == nil
			raise ProductNotFoundError, " #{n} Id does not exist to destroy "
		else	
			return product
		end	
		end
   
   def self.destroy(n) # destroys the product with id as n  
  
		products = Product.all	
		product=self.myfind(n)  
		
   		products.delete_if{|i| i.id==product.id}
   		CSV.open(@@data_path, "wb") do |csv2| #again opening the CSV file and sends the other than deleted product
   	 	csv2 << ["id", "brand", "product", "price"]
   	 	
		products.each do |product|

		csv2 << [product.id, product.brand, product.name , product.price]
   		end
   		   		return product

   		end
   end
 	

 	def self.where(options={}) #it returns the correct brand or name depends on the product passed 

		brand = options[:brand]	
		name = options[:name]	
		
		if brand != nil
			products = self.all.select { |product| product.brand == brand }
			return products
		end
		
		if name != nil
			products = self.all.select { |product| product.name == name }
			return products
		end
	end
	
	
		def update(options={})  #updates the product by matching ID with the passed values
      	data = CSV.read(@@data_path).drop(1)
      	brand = options[:brand]
      	price = options[:price]
      	updated_product = [] #stores the obj of updated product
      	data.each do |i|
   			if i[0]== self.id.to_s
   				if brand != nil
   				i[1] = brand
   				end
   				if price != nil
   				i[3] = price
   				end
   				updated_product =  Product.new(id:i[0], brand: i[1], name: i[2], price: i[3])

   			end
   		end
   		CSV.open(@@data_path, "wb") do |csv| #again opens the CSV file and send the updated data 
   	 		csv << ["id", "brand", "product", "price"]
			data.each do |i|
				csv << i
			end
		 end
		 
	
		return updated_product
	end

end
