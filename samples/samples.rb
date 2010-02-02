# 1. Simple use
class AddOne < MethodHash
  def mymethod(a)
    sleep 3
    a + 1
  end
end 

a = AddOne.new
a            #  {}
a[1]         #  2
a[7]         #  8
a            #  {1=>2, 7=>8}
puts a.dump  #  --- !map:AddOne 
             #  1: 2
             #  7: 8


# 2. With a file
b = AddOne.new '/tmp/one.yml'
b            #  {}
b[1]         #  2
b.dump       #  '/tmp/one.yml' 
c = AddOne.new '/tmp/one.yml'
puts c.inspect #  {1=>2}


# 3. Some protection against data corruption.
class AddTwo < MethodHash
  def mymethod(a)
    a + 2
  end
end 

begin
  d = AddTwo.new '/tmp/one.yml' #  ArgumentError: Path holds class AddOne
rescue
  puts $!
end


# 4. Saving exceptions arising from mymethod.
class AddOneFaulty < MethodHash
  def mymethod(a)
    rand(2)==0 ? raise("Epic Fail!") : a+1
  end
end 

e = AddOneFaulty.new
e[1]                 #  RuntimeError: Epic Fail!  # If something bad happened
e                    #  {1=>"ERROR: Epic Fail!"}
e.retry_errors       #  false
e[1]                 #  RuntimeError: Epic Fail!  # Still keeping the error
e.retry_errors=true  #  true
e[1]                 #  2                         # If better luck this time
e                    #  {1=>2}
 

# 5. A more complex setting
class AddThree < MethodHash
  def initialize(path1=nil, path2=nil, mypath=nil)
    @one = AddOne.new(path1)
    @two = AddTwo.new(path2)
    super(mypath)
  end
  
  def mymethod(a)
    @one[a] + @two[a] - a
  end
   
  def dump
    @one.dump
    @two.dump
    super
  end
end

f = AddThree.new( '/tmp/one.yml', '/tmp/two.yml')
puts f[3]
f.dump


# 6. With two arguments
class Add < MethodHash
  def mymethod(a,b)
    a + b
  end
end
