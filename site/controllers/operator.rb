class Site < Sinatra::Base

    # subscriber = EM::Hiredis.connect
    # subscriber.psubscribe '*'

    # stream :keep_open do |out|
    #   subscriber.on(:pmessage) do |key, channel, message|
    #     subscriber.punsubscribe '*' if out.closed?

    #     out << "#{key}, #{channel}, #{message}" unless out.closed?
    #   end
    # end

  get '/operator' do
    slim :'operator/index'
  end
end
