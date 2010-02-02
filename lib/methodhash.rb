require 'yaml'

class MethodHash < Hash

  attr_accessor :retry_errors, :force_calc
  attr_reader :changed, :path
  alias_method :originalassign, :[]=

  # --- initialize ---
  # A path is optional but necessary if you want to store the Hash to disk.
  def initialize(path=nil)
    unless self.respond_to? :mymethod
      raise ArgumentError, 
            "No calculation method (with name 'mymethod') defined for #{self.class}"
    end
    if self.class.to_s == 'MethodHash'
      raise ArgumentError, "Make a subclass. Don't use MethodHash directly."
    end
    @path = path
    @changed = false 
    @retry_errors = false
    @force_calc = false
    if @path and File.exists? @path
      hash = YAML.load open(@path)
      raise ArgumentError, "Path holds class #{hash.class}" if hash.class != self.class
      self.merge! hash
    end
  end

  # --- [] ---
  # If not previously called with given arguments, calls 'mymethod' 
  # with the arguments and inserts the answer in the Hash.
  # If force_calc is set to true, mymethod is always called.
  # If retry_errors is set to true, mymethod is also called if value 
  # has previously been retrieved but raised an error at that time.
  def [](*arg)
    arg = arg.first if arg.size==1
    if !force_calc and s=super(arg)
      if s.is_a? String and s[0,6]=='ERROR:'
        if @retry_errors
          self.delete arg
          self.[](*arg)
        else
          raise s[7..-1]
        end
      else
        s
      end
    else
      @changed = true
      begin
        originalassign(arg,self.mymethod(*arg))
      rescue
        originalassign(arg,"ERROR: #{$!}")
        raise
      end
    end
  end

  # --- []= ---
  # This method cannot be used.
  def []=(key, value)
    raise "You can't just put values into a #{self.class}."
  end

  # --- dump ---
  # If a path has been given, writes self to that file and returns the path.
  # Otherwise, returns a string containing the dump.
  def dump
    if @path
      if self.changed?
        open(@path,'w'){|f| YAML.dump(self,f) }
        @changed = false
      end
      @path
    elsif !path
      @changed = false
      YAML.dump(self)
    end
  end

  def delete(arg)
    @changed = true
    super
  end

  # --- changed? ---
  # Has something changed since the last call to dump?
  def changed?
    @changed
  end

end
