require "sinatra"
require "sinatra/reloader"
require "better_errors"
require "binding_of_caller"
require "dotenv/load"
require "http"
require "json"


use(BetterErrors::Middleware)
BetterErrors.application_root = __dir__
BetterErrors::Middleware.allow_ip!('0.0.0.0/0.0.0.0')

get("/") do
  exchange_rate_key = ENV.fetch("EXCHANGE_RATE_KEY")
  exchange_rate_url = "https://api.exchangerate.host/list?access_key=#{exchange_rate_key}"
  raw_list = HTTP.get(exchange_rate_url)
  parsed_list = JSON.parse(raw_list)
  currencies = parsed_list.fetch("currencies")
  @currencies_keys = currencies.keys

  erb(:index)
end


get("/:from_currency") do
  @first_currency = params.fetch("from_currency")

  exchange_rate_key = ENV.fetch("EXCHANGE_RATE_KEY")
  exchange_rate_url = "https://api.exchangerate.host/list?access_key=#{exchange_rate_key}"
  raw_list = HTTP.get(exchange_rate_url)
  parsed_list = JSON.parse(raw_list)
  currencies = parsed_list.fetch("currencies")
  @currencies_keys = currencies.keys

  erb(:page_one)
end


get("/:from_currency/:to_currency") do
  @first_currency = params.fetch("from_currency")
  @second_currency = params.fetch("to_currency")

  exchange_rate_key = ENV.fetch("EXCHANGE_RATE_KEY")
  convert_rate_url = "https://api.exchangerate.host/convert?from=#{@first_currency}&to=#{@second_currency}&amount=1&access_key=#{exchange_rate_key}"
  raw_result = HTTP.get(convert_rate_url)
  parsed_result = JSON.parse(raw_result)
  @result = parsed_result.fetch("result")
  puts @result


  erb(:page_two)
end
