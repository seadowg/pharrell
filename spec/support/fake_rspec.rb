class FakeRSpec
  @@befores = Hash.new([])

  def self.before(scope, &blk)
    @@befores[scope] << blk
  end

  def self.befores
    @@befores
  end

  def self.include(modjewel)
    super(modjewel)
  end

  def self.reset!
    @@befores = Hash.new([])
  end
end
