class Site < Sinatra::Base
  get '/' do
    slim :'home/index', layout: :'home/layout'
  end

  # namespace '/live' do
  #   get do
  #     stream do |out|
  #       begin
  #         loop do
  #           out << "#{Time.now} #{rand(1000)}<br/>"
  #           sleep rand 2
  #         end
  #       rescue IOError => e
  #         # closed
  #       end
  #     end
  #   end
  # end

end
