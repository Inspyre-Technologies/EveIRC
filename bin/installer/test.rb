def fast_loop
  start_time = Time.now
  30.times do
    sleep 0.01
    p 'The time is ' + Time.now.strftime('%H:%M:%S.%L')
  end
  end_time = Time.now
  diff = end_time.to_f - start_time.to_f
  p 'This process took ' + diff.to_s + ' seconds'
end
fast_loop
