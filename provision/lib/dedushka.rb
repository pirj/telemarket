class Dedushka
  attr_reader :server

  def initialize server
    @server = server
  end

  def ssh user, &block
    Net::SSH.start server.host, user.name, {password: user.password}, &block
  end

  def root &block
    ssh server.root, &block
  rescue Net::SSH::AuthenticationFailed
    puts "root seems to be disabled"
  end

  def su &block
    ssh server.sudoer, &block
  end

  def std
    @std ||= proc do |channel, stream, data|
      $stdout << data if stream == :stdout
      $stderr << data if stream == :stderr
    end
  end
end
