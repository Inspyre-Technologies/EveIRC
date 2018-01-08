PriceData = 'https://min-api.cryptocompare.com/data/'

def converter(m, qAmount, qSym, target)
  
  data = JSON.parse(open("#{PriceData}price?fsym=#{qSym}&tsyms=#{target}").read)
  
  if data.key?('Response')
    eMsg = data['Message']
    error = "error"
    return error, eMsg
  end
  
  tPrice = data["#{target}"]
  
  total  = tPrice.to_f * qAmount.to_f
  total  = commify(total)
  
  return total
  
end
