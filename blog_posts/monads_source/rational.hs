-- A real valued function f(x) with singularity at y
singular :: Double -> Double -> Maybe Double
singular y y = Nothing
singular y x = Just (1/(y-x))

-- Two instances of singular functions
s_5, s_3 :: Double -> Maybe Double
s_5 = singular 5.0
s_3 = singular 3.0
