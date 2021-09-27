-- A real valued function f(x) with asymptote at y
asymptote :: Double -> Double -> Maybe Double
asymptote y y = Nothing
asymptote y x = Just (1/(y-x))

-- Two instances of asymptote functions
as_5, as_3 :: Double -> Maybe Double
as_5 = asymptote 5.0
as_3 = asymptote 3.0
