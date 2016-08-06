$_rb_cache_f = {}
$_rb_cache_g = {}


def fval_eval(p1, p2, t)
  3 * (1 - t) ** 2 * t * p1 + 3 * (1 - t) * t ** 2 * p2 + t ** 3 
end


def gval_eval(p1, p2, t)
  3 * (1 - t) ** 2 * p1 + 6 * (1 - t) * t * (p2 - p1) + 3 * t ** 2 * (1 - p2) 
end

def find_y(p1_x, p1_y, p2_x, p2_y, x, tol=1E-6, itr_bin=5, itr_newton=8)
  t, f, tl, tr = 0.0, 0.0, 0.0, 1.0
  do_newton = true
  itr_bin.times do |i|
    tm = (tl + tr) / 2
    fl = $_rb_cache_f[tl] || ($_rb_cache_f[tl] = fval_eval(p1_x, p2_x, tl))
    fm = $_rb_cache_f[tm] || ($_rb_cache_f[tm] = fval_eval(p1_x, p2_x, tm))
    if (fl - x).abs < tol
      f = fl; t = tl; do_newton = false
      break
    end
    if (fm - x).abs < tol
      f = fm; t = tm; do_newton = false
      break
    end
    (fl - x) * (fm - x) < 0 ? tr = tm : tl = tm
  end
  t = (tl + tr) / 2 if do_newton

  itr = 0
  while do_newton && itr < itr_newton
    f = $_rb_cache_f[t] || ($_rb_cache_f[t] = fval_eval(p1_x, p2_x, t))
    break if (f - x).abs < tol
    df = $_rb_cache_g[t] || ($_rb_cache_g[t] = gval_eval(p1_x, p2_x, t))
    t -= (f - x) / df
    itr += 1
  end
  if (f - x).abs < tol && t <= 1 && t >= 0
    fval_eval(p1_y, p2_y, t)
  else
    nil
  end
end

y = (0...1000).to_a.map do |i|
  x = 1.0 * i / 1000
  find_y(0.09, -0.31, 0.91, -0.16, x)
end

p y.select{|e| e.nil? }.size
p y[0], y[500]

#p find_y(0.5, 0.5, 1.0, 1.0, 0.5)
#p $_rb_cache_f
#p $_rb_cache_g
#t = Time.now
#1000.times {find_y(0.7, 0.9, 0.3, 0.6, 0.9)}
#t = Time.now - t
#p t
#p find_y(0, 0.4, 0.3, 1.2, 0.4)

