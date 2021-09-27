instance Monad Maybe where
    (Just x) >>= f = f x
    Nothing  >>= _ = Nothing
    -- Notice that when the value is Nothing,
    -- we don't compute the function f
