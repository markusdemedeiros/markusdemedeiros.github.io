data Maybe a = Just a | Nothing

instance Functor Maybe where
    fmap f (Just a) = Just (f a)
    fmap f Nothing = Nothing
