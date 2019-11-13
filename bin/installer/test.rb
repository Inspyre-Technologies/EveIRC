@fast_loops = 1 unless @fast_loops
@pkg_loops = 1 unless @pkg_loops
@total_loops = @fast_loops + @pkg_loops

def fast_loop
  start_time = Time.now
  30.times do
    sleep 0.05
    p 'The time is ' + Time.now.strftime('%H:%M:%S.%L')
    @fast_loops = @fast_loops + 1
    n = 'loops' unless  @fast_loops == 1

        when >= 2
          'loops'
    
        else
          'loop'
        end
    p 'I have carried out ' + @fast_loops.to_s + 'fast ' + n 
  end
  end_time = Time.now
  diff = end_time.to_f - start_time.to_f
  p 'This process took ' + diff.to_s + ' seconds'
  return diff.to_s
end

def loop_pkg
  running_times = []
  until running_times.count >= 31
    fl_results = fast_loop
    running_times << fl_results
  end
  running_times = convert_to_f running_times
  p running_times.sum
end

def convert_to_f(arr)

  arr.collect do |value|
    value.to_f
  end

end
loop_pkg
    
